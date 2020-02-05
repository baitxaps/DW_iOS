//
//  ProfileViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class WBProfileTableViewController: VisitorTableViewController {
    private lazy var emoticonView:EmojiIconView = EmojiIconView()
    private var textView:UITextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: nil,title:"关注一些人，回这里看看有什么惊喜")
        
        setupUI()
    }
}

extension WBProfileTableViewController {
    private func setupUI() {
        tableView.addSubview(textView)
        textView.inputView = emoticonView
        textView.becomeFirstResponder()
        
        textView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
    }
}
