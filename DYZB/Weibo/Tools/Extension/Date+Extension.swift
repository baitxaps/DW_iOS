//
//  Date+Extension.swift
//  DYZB
//
//  Created by hairong chen on 2020/3/7.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation

// 日期格式化器 - 不要频繁的释放和创建，会影响性能
private let dateFormatter = DateFormatter()
// 当前日历对象
private let calendar = Calendar.current

extension Date {
    
    // 计算与当前系统时间偏差 delta 秒数的日期字符串
    // 在 Swift 中，如果要定义结构体的 `类`函数，使用 static 修饰 -> 静态函数
    static func dateString(delta: TimeInterval) -> String {
        
        let date = Date(timeIntervalSinceNow: delta)
        // 指定日期格式
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en")
        
        return dateFormatter.string(from: date)
    }
    
    /// 将新浪格式的字符串转换成日期
    ///
    /// - parameter string:Sat Mar 07 23:45:32 +0800 2020
    ///
    /// - returns: 日期
    static func sinaDate(string: String) -> Date? {
        // 设置日期格式 EEEE:星期，zzz：时区
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzzz yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        // 转换并且返回日期
        return dateFormatter.date(from: string)
    }
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
    */
    var dateDescription: String {
        // 1. 判断日期是否是今天
        if calendar.isDateInToday(self) {
        
            let delta = -Int(self.timeIntervalSinceNow)
            
            if delta < 60 {
                return "刚刚"
            }
            
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            
            return "\(delta / 3600) 小时前"
        }
        
        // 2. 其他天
        var fmt = " HH:mm"
        
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd" + fmt
            
            // 直接获取年的数值
            let year = calendar.component(.year, from: self)
            
            // 比较两个日期之间是否有一个完整的年度差值
            let thisYear = calendar.component(.year, from: Date())
            
            if thisYear > 0 {
                print("一年前")
            }
            else {
              print("当年")
            }
     
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }
        
        // 设置日期格式字符串
        dateFormatter.dateFormat = fmt
        
        return dateFormatter.string(from: self)
    }
}
