//
//  NewsModel.swift
//  DW_iOS
//
//  Created by hairong chen on 2019/12/16.
//  Copyright @huse.cn  All rights reserved.
//

import UIKit

class NewsModel: NSObject {
   @objc var quality:Int = 0
   @objc var title:String? = ""
   @objc var imgsrc:String? = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
//    override func setValue(_ value: Any?, forKey key: String) {
//         ///这句话很关键,一定要有
//         super.setValue(value, forKey: key)
//     }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
