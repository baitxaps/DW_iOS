//
//  DiscoverViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class WBDiscoverTableViewController: VisitorTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: nil,title:"关注一些人，回这里看看有什么惊喜")
    }
}
