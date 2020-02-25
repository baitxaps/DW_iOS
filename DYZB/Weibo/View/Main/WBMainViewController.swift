//
//  MainViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class WBMainViewController: UITabBarController {
// MARK:- lazy var composedButton
    private lazy var composedButton:UIButton = UIButton(imageName:
        "tabbar_compose_icon_add", backImageName:"tabbar_compose_button")
    
    @objc private func clickComposedButton() {
        print("clickComposedButton")
        
        var vc:UIViewController
        if UserAccountViewModel.shared.userLogin {
            vc = ComposeViewController()
        }else {
            vc = OAuthViewController()
        }
    
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(nav, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild()
        setupComposedButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.bringSubviewToFront(composedButton)
    }
}
//CGRect CGRectInset(CGRect rect, CGFloat dx, CGFloat dy)：
/*
 !!! 正：左右往里缩,负相反
通过第二个参数 dx 和第三个参数 dy 重置第一个参数 rect 作为结果返回。
 重置的方式为，首先将 rect 的坐标（origin）按照(dx,dy) 进行平移，
 然后将 rect 的大小（size） 宽度缩小2倍的 dx，高度缩小2倍的 dy
*/
extension WBMainViewController {
    private func setupComposedButton() {
        tabBar.addSubview(composedButton)
        
        let count = children.count
        let width = tabBar.bounds.width / CGFloat(count)
        /// OC :CGRectInset
        composedButton.frame = tabBar.bounds.insetBy(dx:2*width,dy: 0);
        
        composedButton.addTarget(self,action:#selector(clickComposedButton),for:.touchUpInside)
    }
// MARK:- addChild
    private func addChild() {
        addChild(vc: WBHomeTableViewController(),title: "首页",imageName: "tabbar_home")
        addChild(vc: PicturePickerController(),title: "消息",imageName: "tabbar_message_center")
//        addChild(vc: MessageTableViewController(),title: "消息",imageName: "tabbar_message_center")
     // addChild(vc: UIViewController(),title:"" ,imageName:"")
        addChild(UIViewController())
        addChild(vc: WBDiscoverTableViewController(),title: "发现",imageName: "tabbar_discover")
        addChild(vc: WBProfileTableViewController(),title: "我的",imageName: "tabbar_profile")
    }
    
    private func addChild(vc:UIViewController,title:String,imageName:String) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named:imageName)
        
        let nav = UINavigationController(rootViewController:vc)
        addChild(nav)
    }
}
