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
    
    private var tokenDict:[String:String]? {
        if let token = UserAccountViewModel.shared.accesstoken {
            return ["access_token":token]
        }
        return nil
    }
    
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
    
    
    class func upload(URLString: String, parameters: [String: AnyObject]?, data:Data, name: String, finishedCallback :@escaping (_ result :Any,_ error:Error?) ->()){
        // name:服务器接收文件的参数名（判断是哪一张图片）
        // fileName:服务器获取到图片的名称
        // mimeType:文件类型, 告诉服务器上传文件的类型，如果不想告诉，可以使用application/octet-stream
        // image/* , ( image/png image/jpg image/gif)
        
        // php
        //'file' 对应客户端的name字段名
        //$file = isset($_FILES['file']) ? $_FILE['file'] : null;
        
        Alamofire.upload(multipartFormData: { (formData) in
            // 这里传递更多参数
            formData.append(data, withName: name, fileName: "picFile", mimeType: "application/octet-stream")
            
        }, to: URL(string:URLString)!) { (result) in
            print("数据准备完成")
            switch result {
            case .success(let upload, _, _):
                upload.responseString(completionHandler: { (respone) in
                    print(respone)
                    finishedCallback(respone ,nil)
                })
                
            case .failure(let err):
                 finishedCallback([:],err)
                break
            }
        }
    }
}
