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
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    override var description: String {
        let keys = ["id","created_at","text","source"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
