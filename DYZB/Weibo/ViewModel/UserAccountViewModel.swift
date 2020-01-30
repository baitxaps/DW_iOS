//
//  UserAccountViewModel.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/19.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation
/**
 模型通常继承自NSObject-> 可以使用KVC设置属性，简化对象构造
 如果没有父类，所有的内容，都需要从头创建，量级更轻
 视图模型：封装‘业务逻辑’，通常没有复杂的属性
 */
class UserAccountViewModel {
    // single Instance
    static let shared = UserAccountViewModel()
    
    var account:UserAccount?
    
    var accesstoken :String? {
        if !isExpired {
            return account?.access_token
        }
        return nil
    }
    
    var userLogin:Bool {
        return account?.access_token != nil && !isExpired //false//
    }
    
    var avatarUrl:URL {
        return URL(string: account?.avator_large ?? "http://www.avator.com")!
    }
    
    // 计算型属性，类似于有返回值的函数
    private var accountPath:String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return  (path as NSString).appendingPathComponent("account.plist")
    }
    
    private var isExpired:Bool {
        //--> expiresDate > Date() =>orderedDescending
        // account?.expiresDate = Date(timeIntervalSinceNow: -3600) as NSDate
        if account?.expiresDate?.compare(Date()) == ComparisonResult.orderedDescending {
            return false
        }
        return true
    }
    
    //    private func accountPath() ->String {
    //        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    //        return  (path as NSString).appendingPathComponent("account.plist")
    //    }
    
    private init() {
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        
        if isExpired {
            account = nil
        }
    }
}

extension UserAccountViewModel {
    func loacAccessToken(code:String,finished:@escaping(_ isSuccess:Bool)->()) {
        print("授权码 - \(code)")
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI]
        
     
        // 使用授权码获取[换取] AccessToken
        NetworkTools.requestData(.post, URLString: urlString, parameters: params) { (result,error) in
            if error != nil {
                finished(false)
                return
            }
            print(result)
            // 解析模型...
            guard let resultDict = result as? [String : AnyObject] else {
                finished(false)
                return
            }
            
            self.account = UserAccount(dict:resultDict)
           
            self.loadUserInfo(userAccount: self.account!,finished:finished)
        }
    }
    
    // 加载用户信息
    private func loadUserInfo(userAccount:UserAccount,finished:@escaping(_ isSuccess:Bool)->()) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        guard let uid = userAccount.uid else {
            finished(false)
            return
        }
        
        guard let access_token = userAccount.access_token else {
            finished(false)
            return
        }
        
        let params = ["uid": uid,"access_token":access_token ]
        NetworkTools.requestData(.get, URLString: urlString, parameters:params as [String : AnyObject]) { (result,error) in
            
            if error != nil {
                finished(false)
                return
            }
            
            print(result)
            guard let response = result as? [String : AnyObject] else {
                finished(false)
                return
            }
            userAccount.avator_large = response["avator_large"] as? String
            userAccount.screen_name = response["screen_name"] as? String
            
            NSKeyedArchiver.archiveRootObject(userAccount, toFile: self.accountPath)
            //userAccount.saveUserAccount()
            finished(true)
        }
    }
}

