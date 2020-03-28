//
//  MainViewController.swift
//  DYZB
//
//  Created by hairong chen on  9/12.
//  Copyright @huse.cn All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        learnTest()
        addChildVc("Home")
        addChildVc("Live")
        addChildVc("Follow")
        addChildVc("Profile")
    }
    
    fileprivate func learnTest() {
        let obj = ItHemaView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.addSubview(obj)
        
        print(HttpTools.shared2)
        print(HttpTools.shared())
        
        obj.jsonTest()
//        obj.classObjTest()
//        obj.closureTest {print("callback exec.")}
//        obj.closureTestparams { (html) in
//            print(html)
//        }
//        obj.arrayAnddictTest()
//        obj.circleTest()
//        obj.test()
//        obj.stringTest()
    }

    fileprivate func addChildVc(_ storyName : String) {
        // 1.通过storyboard获取控制器
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        // 2.将childVc作为子控制器
        addChild(childVc)
    }
}
