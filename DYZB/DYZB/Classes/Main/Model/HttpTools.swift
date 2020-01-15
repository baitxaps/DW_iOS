//
//  HttpTools.swift
//  DYZB
//
//  Created by hairong chen on .
//  Copyright @huse.cn  All rights reserved.

//  http://httpbin.org
//  https://flatuicolors.com 调色板
//  https://appicon.co/#image-sets
//  https://www.canva.com 作品设计
// option + K:˚

import UIKit
//http://c.m.163.com/nc/article/list/T1348649079062/0-20.html
class HttpTools: NSObject {
    var finishedCb:((_ jsonData:String)->())?
    
    func loadData(_ finishedCallback:@escaping (_ jsonData:String)->()) {
        self.finishedCb = finishedCallback
        
        DispatchQueue.global().async {
            print("async:\(Thread.current)")
            DispatchQueue.main.sync {
                print("return main:\(Thread.current)")
                finishedCallback("JsonData")
            }
        }
    }
}

//class HttpTools: NSObject {
//    func loadDat(finishedCallback:()->()) {
//        finishedCallback()
//        DispatchQueue.global().async {
//            print("async:\(Thread.current)")
//            DispatchQueue.main.sync {
//                print("return main:\(Thread.current)")
//
//            }
//        }
//    }
//}

func post(name:String,password:String) {
    
    let session = URLSession(configuration: .default)
    // 设置URL(该地址不可用，写你自己的服务器地址)
    let url = "http://66.666.666.666/"
    var request = URLRequest(url: URL(string: url)!)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    // 设置要post的内容，字典格式
    let postData = ["name":"\(name)","password":"\(password)"]
    let postString = postData.compactMap({ (key, value) -> String in
        return "\(key)=\(value)"
    }).joined(separator: "&")
    request.httpBody = postString.data(using: .utf8)
    // 后面不解释了，和GET的注释一样
    let task = session.dataTask(with: request) {(data, response, error) in
        do{
            // 将二进制数据转换为字典对象
            if let jsonObj:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? NSDictionary
            {
                print(jsonObj)
                //主线程
                DispatchQueue.main.async{
                    
                }
            }
        } catch{
            print("Error.")
            DispatchQueue.main.async{
                
            }
            
        }
    }
    task.resume()
}



























