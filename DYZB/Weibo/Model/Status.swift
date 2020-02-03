//
//  Status.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/31.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

@objcMembers
class Status: NSObject {
    var id :Int = 0         // 微博ID
    var created_at:String?  // 微博创建时间
    var text :String?       // 微博信息内容
    var source :String?     // 微博来源
    var user:User?          // User model
    var pic_urls:[[String:String]]? // key:thumbnail_pic
    var retweeted_status:Status?    //被转发的原微博信息字段，当该微博为转发微博时返回
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        // User
        if key == "user" {
            if let dict = value as? [String:AnyObject] {
                user = User(dict:dict)
            }
            return
        }
        
        // retweeted_status
        if key == "retweeted_status" {
            if let dict = value as? [String:AnyObject] {
                retweeted_status = Status(dict:dict)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    override var description: String {
        let keys = ["id","created_at","text","source","user","pic_urls","retweeted_status"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
