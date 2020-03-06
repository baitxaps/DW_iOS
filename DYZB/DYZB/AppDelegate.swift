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
        
        //testSwiftBridgeOC()
        testSwiftBridgeFMDB()
        
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(forName:NSNotification.Name( WBSwitchRootViewControllerNotification), object: nil, queue: nil) { [weak self] (notification) in
            print(Thread.current)
            print(notification)
            if let _ = notification.object {
                self?.window?.rootViewController = WelcomeViewController()
            }else {
                self?.window?.rootViewController = WeiBoMainViewController()
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
    
    
    func applicationDidEnterBackground(_ application: UIApplication){
        StatusDAL.clearDataCache()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name( WBSwitchRootViewControllerNotification), object: nil)
    }
}

// MARK:- switch page
extension AppDelegate {
    //
    private var defaultRootViewController:UIViewController {
        
        if UserAccountViewModel.shared.userLogin {
            return isNewVersion ? NewFeatureViewController():WelcomeViewController()
        }
        
        return WeiBoMainViewController()
    }
    
    private var isNewVersion:Bool {
        // print(Bundle.main.infoDictionary!)
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let version = Double(currentVersion)!
        print(version)
        
        let sandboxVersKey = "sandboxVersKey"
        let sandboxVersion = UserDefaults.standard.double(forKey:sandboxVersKey)
        print(sandboxVersion)
        
        UserDefaults.standard.set(currentVersion,forKey:sandboxVersKey)
        return version > sandboxVersion
    }
}

//MARK:-  oc bridge file
extension AppDelegate {
    
    func testSwiftBridgeFMDB() {
       // let shared = FMDBManager.sharedManager
       // let p = DataBaseAPI(dict: [:])
        
        // SQL 注入
//        p.fmdbInsert(name: "William,0,0);DELETE FROM T_Person; --")
//        p.fmdbInsert(name: "William")
        
       let _ =  FMDBManager.sharedManager
    }

    
    func testSwiftBridgeOC() {
        // 持久化连接，只做打开数据库动作，不做关闭数据库动作
        // 后续再使用时，直接做读写操作,效率更高。通常移动端用持久化连接
        
        SQLiteManager.sharedManager.openDB(dbName: "test.db")
        
        var p = DataBaseAPI(dict:["id":2,"name":"zhansan","age":18,"height":1.7])
        if p.insertPosition() {
            print("insertData success:\(p)")
        }
        
        p = DataBaseAPI(dict:["id":3,"name":"william","age":19,"height":1.8])
        if p.updatePosition() {
            print("update success:\(p)")
        }
        
        p = DataBaseAPI(dict:["id":4,"name":"zhansan","age":19,"height":1.8])
        if p.deletePosiont() {
            print("delete success:\(p)")
        }
        
        // select
        //print(DataBaseAPI.Positons())
        
       // p.manyPositions()
        
        let dao = Dao()
        dao.name = "z"
      
    }
}
