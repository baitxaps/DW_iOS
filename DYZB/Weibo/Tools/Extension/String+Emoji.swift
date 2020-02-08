//
//  String+Emoji.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/8.
//  Copyright © 2020 @huse.cn. All rights reserved.
// #import "Product-Swift.h"

import Foundation

// swift 和 oc 共用
extension NSString {
    // 返回当前字符串中16进帛的emoji字符串
    var emoji:String {
        // text scanner
        let scanner = Scanner(string:(self as String))
        var value :UInt32 = 0
        
        // unicode value
        scanner.scanHexInt32(&value)
        // unicode character
        let chr = Character(UnicodeScalar(value) ?? UnicodeScalar(0))
        
        // string
        return "\(chr)"
    }
}
