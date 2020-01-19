//
//  NetworkTools.swift
//  Alamofire的测试
//
//  Created by hairong chen on  9/19.
//  Copyright @huse.cn All rights reserved.
//

import UIKit
import Alamofire

enum RequestMethod:String {
    case GET = "GET"
    case POST = "POST"
}

enum MethodType {
    case get
    case post
}



class NetworkTools {
    typealias RequestCallBack = (_ result : Any) -> ()
    
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :@escaping (_ result : Any) -> ()/*RequestCallBack*/) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error ?? "")
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }
    }
    
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :@escaping (_ result :Any,_ error:Error?) -> ()/*RequestCallBack*/) {
          
          // 1.获取类型
          let method = type == .get ? HTTPMethod.get : HTTPMethod.post
          
          // 2.发送网络请求
          Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
              
              // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error ?? "")
                finishedCallback([:],response.result.error)
                return
            }
              
              // 4.将结果回调出去
            finishedCallback(result,response.result.error)
          }
      }
}
