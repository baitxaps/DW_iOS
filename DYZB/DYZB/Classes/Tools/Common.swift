//
//  Common.swift
//  DYZB
//
//  Created by hairong chen on  9/14.
//  Copyright @huse.cn All rights reserved.
//

import UIKit

let kStatusBarH : CGFloat = 20
let kNavigationBarH : CGFloat = 44
let kTabbarH : CGFloat = 44

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kIndicator:CGFloat = 100

// the same like .pch file
let WBAppearanceTintColor = UIColor.orange

// switch rootvc for notification
let WBSwitchRootViewControllerNotification = "WBSwitchRootViewControllerNotification"
// MARK: - 应用程序信息
/// 应用程序 ID
let WBAppKey = "2630329609"
/// 应用程序加密信息(开发者可以申请修改)
let WBAppSecret = "b6d86db3a453c7298855335ddd525e4a"
/// 回调地址 - 登录完成调转的 URL，参数以 get 形式拼接
let WBRedirectURI = "https://sns.whalecloud.com/sina2/callback"


func delay(delta:Double,execute closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline:.now() + delta) {
        closure()
    }
}
