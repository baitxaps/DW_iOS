//
//  DisatchQueue+Extension.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/17.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
