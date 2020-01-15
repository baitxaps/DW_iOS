//
//  AppDelegate.swift
//  DYZB
//
//  Created by hairong chen on  9/12.
//  Copyright @huse.cn All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = WeiBoMainViewController()
        window?.makeKeyAndVisible()
        return true
    }

//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//        UITabBar.appearance().tintColor = UIColor.orange
//
//        return true
//    }
    
}

