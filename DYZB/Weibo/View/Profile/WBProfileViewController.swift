//
//  ProfileViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class WBProfileTableViewController: VisitorTableViewController {
    private lazy var emoticonView:EmoticonView = EmoticonView()
    private var textView:UITextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView?.setupInfo(imageName: nil,title:"关注一些人，回这里看看有什么惊喜")
        
        setupUI()
        print(EmoticonViewModel())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
}

extension WBProfileTableViewController {
    private func setupUI() {
        tableView.addSubview(textView)
        textView.inputView = emoticonView
        
        
        textView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(view.snp.bottom).offset(-safeBottomHeight())
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
     }
}
