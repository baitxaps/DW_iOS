//
//  VisitorTableViewController.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class VisitorTableViewController: UITableViewController {
    deinit {
        if userLogon {
            tableView.dg_removePullToRefresh()
        }
    }

    private var userLogon = UserAccountViewModel.shared.userLogin
    
    var visitorView :VisitorView?
    
    override func loadView() {
        userLogon ? super.loadView():setupVisitorView()
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if userLogon {
//            addPullToRefresh()
//        }
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
    
    private func addPullToRefresh() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
}
