//
//  ComposeViewModel.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/23.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation
import UIKit

class ComposeViewModel {
//    let json = JSON(data: dataFromNetworking)
//    if let userName = json[0]["user"]["name"].string {
//      // Now you got your value
//    }
}


extension ComposeViewModel {
/// - see:[https://open.weibo.com/wiki/2/statuses/update](https://open.weibo.com/wiki/2/statuses/update)
    
    class func postStatus(status:String, image: UIImage?, finishedCallback :@escaping (_ result :Any,_ error:Error?) -> ()) {
    
        guard let token = UserAccountViewModel.shared.accesstoken else { return }
        
        var params = [String:String]()
        params["status"] = status
        params["access_token"] = token
        
        var fileName: String?
        var data: Data?
        if image != nil {
            fileName = "pic"
            data = image!.pngData()
        }

        let urlString: String
        if image == nil {
            urlString = "https://api.weibo.com/2/statuses/update.json"
            NetworkTools.requestData(.post, URLString: urlString, parameters:params) { (response, error) in
                finishedCallback(response,error)
            }
            
        } else {
            guard let data = data else {return}
            
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
            NetworkTools.upload(URLString: urlString, parameters:params as [String : AnyObject], data: data, name:fileName!) { (response, error) in
                
                finishedCallback(response,error)
            }
        }
    }
}
