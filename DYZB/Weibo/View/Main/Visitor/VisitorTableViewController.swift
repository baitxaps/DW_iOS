//
//  VisitorTableViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class VisitorTableViewController: UITableViewController {
    private var userLogon = false
    
    var visitorView :VisitorView?
    
    override func loadView() {
        userLogon ? super.loadView():setupVisitorView()
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
    private func setupVisitorView() {
        visitorView = VisitorView()
        visitorView?.delegate = self
        view = visitorView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style:.plain, target: self, action: #selector(visitorViewDidRegister))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style:.plain, target: self, action: #selector(visitorViewDidLogin))
    }
}

extension VisitorTableViewController : VisitorViewDelegate {
    @objc func visitorViewDidRegister() {
        print("register")
    }
    
    @objc func visitorViewDidLogin() {
        print("login")
        let vc = OAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
