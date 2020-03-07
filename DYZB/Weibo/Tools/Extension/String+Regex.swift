//
//  String+Regx.swift
//  DYZB
//
//  Created by hairong chen on 2020/3/7.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation
extension String {
    
    // 从当前字符串中，提取链接和文本
    // Swift 提供了`元组`，同时返回多个值
    // 如果是 OC，可以返回字典／自定义对象／指针的指针
    func href() -> (link: String, text: String)? {
        
        // 匹配方案 "<a href=\"http://www.baidu.com/\">微博 weibo.com</a>"
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        // 创建正则表达式，并且匹配第一项
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))
            else {
                return nil
        }
        
       // self.printReslut(result:result, str: self)

        // 获取结果
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        
        return (link, text)
    }
    
    //
    private  func printReslut(result:NSTextCheckingResult, str:String) {
        DLog(message:result)
        DLog(message:"查找范围的个数\(result.numberOfRanges)")
        
        // 获取第0个范围
        let r = result.range(at: 0)
        let s = (str as NSString).substring(with: r)
        DLog(message:s)
    }
    
//    private func call() {
//        
//    }
}

