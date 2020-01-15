//
//  NSDate-Extension.swift
//  DYZB
//
//  Created by hairong chen on  9/19.
//  Copyright @huse.cn All rights reserved.
//

import Foundation


extension Date {
    static func getCurrentTime() -> String {
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
