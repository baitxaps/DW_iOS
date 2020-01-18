//
//  OAuthViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/18.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        webView.delegate = self
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style:.plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", style: .plain, target: self, action: #selector(autoFill))
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func autoFill() {
        let js = "document.getElementById('userId').value = '10086@sina.cn'; " +
        "document.getElementById('passwd').value = '123$123';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// OAuth URL
        /// - see:[http://open.weibo.com/wiki/Oauth2/authorize](http://open.weibo,com/wiki/Oquth2/authorize)
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }

}

extension OAuthViewController:UIWebViewDelegate {
     func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
       
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            close()
            return false
        }
        
        // code=15be12d79321e474c599210ef637c978
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI]
        
        print("授权码 - \(code)")
        // 使用授权码获取[换取] AccessToken
        NetworkTools.requestData(.post, URLString: urlString, parameters: params) { (result) in
            print(result)
            // 解析模型...
            guard let resultDict = result as? [String : AnyObject] else { return }
            
            let account = UserAccount(dict:resultDict)
            print(account)
            self.close()
        }
        return false
    }
    
    //MARK:- loadUserInfo
    private func loadUserInfo(userAccount:UserAccount) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        guard let uid = userAccount.uid else {
            return
        }
        
        let params = ["uid": uid ]
        NetworkTools.requestData(.post, URLString: urlString, parameters:params as [String : AnyObject]) { (result) in
            print(result)
            guard let response = result as? [String : AnyObject] else {
                return
            }
            userAccount.avator_large = response["avator_large"] as? String
            userAccount.screen_name = response["screen_name"] as? String
        }
    }
}
