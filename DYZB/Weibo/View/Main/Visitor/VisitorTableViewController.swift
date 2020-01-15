//
//  VisitorTableViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class VisitorTableViewController: UITableViewController {
    private var userLogon = true
    
    override func loadView() {
        userLogon ? super.loadView():setupVisitorView()
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
    private func setupVisitorView() {
        view = UIView()
        view.backgroundColor = UIColor.green
    }
}
