//
//  Position.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/12.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

@objcMembers
class Position: NSObject {
    var name:String? 
    var age :Int = 0
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

    override var description:String {
        let keys = ["name","age"]
        return "\(dictionaryWithValues(forKeys: keys))"
    }
}


