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
    #if true
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupAppearance()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = defaultRootViewController
        // WelcomeViewController()
        // WBMainViewController()
        // NewFeatureViewController()
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(forName:NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), object: nil, queue: nil) { [weak self] (notification) in
            print(Thread.current)
            print(notification)
            if let _ = notification.object {
                self?.window?.rootViewController = WelcomeViewController()
            }else {
                self?.window?.rootViewController = WBMainViewController()
            }
        }
        
        return true
    }
    #else
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor.orange
        
        return true
    }
    #endif
    
    private func setupAppearance() {
        UINavigationBar.appearance().tintColor = WBAppearanceTintColor
        UITabBar.appearance().tintColor = WBAppearanceTintColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), object: nil)
    }
}

// MARK:- switch page
extension AppDelegate {
    //
    private var defaultRootViewController:UIViewController {
        
        if UserAccountViewModel.shared.userLogin {
            return isNewVersion ? NewFeatureViewController():WelcomeViewController()
        }
        
        return WBMainViewController()
    }
    
    private var isNewVersion:Bool {
       // print(Bundle.main.infoDictionary!)
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let version = Double(currentVersion)!
        print(version)
        
        let sandboxVersKey = "sandboxVersKey"
        let sandboxVersion = UserDefaults.standard.double(forKey: sandboxVersKey)
        print(sandboxVersion)
        
        UserDefaults.standard.set(sandboxVersion,forKey: sandboxVersKey)
        return version > sandboxVersion
    }
}

