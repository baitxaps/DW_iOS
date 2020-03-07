//
//  NetworkTools.swift
//  Alamofire的测试
//
//  Created by hairong chen on  9/19.
//  Copyright @huse.cn All rights reserved.
//

import UIKit
import Alamofire

//enum RequestMethod:String {
//    case GET = "GET"
//    case POST = "POST"
//}

enum MethodType {
    case get
    case post
}

class NetworkTools {
    typealias RequestCallBack = (_ result : Any) -> ()
    
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :@escaping (_ result : Any) -> ()/*RequestCallBack*/) {
        // 显示网网络指示器
        // UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            //UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let result = response.result.value else {
                print(response.result.error ?? "")
                return
            }
            finishedCallback(result)
        }
    }
    
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :@escaping (_ result :Any,_ error:Error?) -> ()/*RequestCallBack*/) {
     
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
   
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error ?? "")
                finishedCallback([:],response.result.error)
                return
            }
            finishedCallback(result,response.result.error)
        }
    }
    
    // name:服务器接收文件的参数名（判断是哪一张图片）
    // fileName:服务器获取到图片的名称
    // mimeType:文件类型, 告诉服务器上传文件的类型，如果不想告诉，可以使用application/octet-stream
    // image/* , ( image/png image/jpg image/gif)
    // php
    //'file' 对应客户端的name字段名
    // $file = isset($_FILES['file']) ? $_FILE['file'] : null;
    class func upload(URLString: String, parameters: [String: AnyObject]?, data:Data, name: String, finishedCallback :@escaping (_ result :Any,_ error:Error?) ->()){
        
        Alamofire.upload(multipartFormData: { (formData) in
            // 加更多参数
            formData.append(data, withName: name, fileName: "pic", mimeType: "application/octet-stream")
            // 遍历参数字典，生成对应的参数数据
            if let parameters = parameters {
                
                for (k,v) in parameters {
                    
                    let str = v as! String
                    let strData = str.data(using: String.Encoding.utf8)
                    
                    // strData 是V的二进制数据，name是k
                    formData.append(strData!, withName: k)
                }
            }
            
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
    
    /*
     upload the file length limit to 5mb
     文件上传和字典参数
     appendBody 方法中，如果带mimeType 是拼接上传文件的方法
     appendBody,如果不带 mimeType 是拼接普通的二进制参数方法
     */
    class func limitToUpload(URLString: String, parameters: [String: AnyObject]?, data:Data, name: String, finishedCallback :@escaping (_ result :Any?,_ error:Error?) ->()){
        Alamofire.upload(multipartFormData: { (formData) in
            
            // 拼接上传二进制数据
            formData.append(data, withName: name, fileName: "pic", mimeType: "application/octet-stream")
            
            // 遍历参数字典，生成对应的参数数据
            if let parameters = parameters {
                
                for (k,v) in parameters {
                    
                    let str = v as! String
                    let strData = str.data(using: String.Encoding.utf8)
                    
                    // strData 是V的二进制数据，name是k
                    formData.append(strData!, withName: k)
                }
            }
        }, usingThreshold: 5 * 1024 * 1024, to: URLString, method:.post, headers: nil) { (encodingResult) in
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { (response) in
                    
                    if response.result.isFailure {
                        print("网络请求失败\(response.result.error)")
                    }
                    
                    finishedCallback(response.result.value as Any ,response.result.error)
                }
                
            case .failure(let err):
                
                finishedCallback(nil,err)
                
                break
            }
        }
    }
}

extension NetworkTools {
    class func appendToken(paramters:inout [String : Any]?) -> Bool {
        guard let token = UserAccountViewModel.shared.accesstoken else {
            return false
        }
        
        if paramters == nil {
            paramters = [String:Any]()
        }
        paramters!["access_token"] = token
        
        return true
    }
    
    class func tokenRequest(_ type : MethodType, URLString : String,parameters:[String : Any]?=nil, finishedCallback :@escaping (_ result : Any,_ error:Error?) -> ()) {
        
        guard let token = UserAccountViewModel.shared.accesstoken else {
            
            finishedCallback([:],NSError(domain: "huse.cn.error", code: -1001, userInfo: ["message":"token is nil"]))
            return;
        }
        var tmpParams = [String : Any]()
        
        tmpParams["access_token"] = token
        for(key,value) in (parameters ?? [:]) {tmpParams[key] = value}
        
        NetworkTools.requestData(type,URLString:URLString,parameters:tmpParams, finishedCallback:finishedCallback)
    }
 
//    typealias Finished = (_ result: Any,_ error: Error?) -> ()
//    func testData(method:Alamofire.Method,URLString:String,paramters:[String:Any]?,finished:@escaping Finished) {
//        Alamofire.request(URLString, method: HTTPMethod.get, parameters:paramters).responseJSON { (response) in
//            if response.result.isFailure {
//                print("网络请求失败\(String(describing: response.result.error) )")
//            }
//            finished(response.result.value,response.result.error)
//        }
//    }
}
