//
//  ProfileViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
// self->emoticonView ->clouse->self
class WBProfileTableViewController: VisitorTableViewController {
    
    private lazy var emoticonView:EmoticonView = EmoticonView {[weak self](emotion) in
        self?.textView.text = emotion.chs
    }
    
    fileprivate lazy var textView:UITextView = {
        let tv = UITextView()
        tv.frame = CGRect(x: 0, y: -200,width: kScreenW, height: 200)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView?.setupInfo(imageName: nil,title:"关注一些人，回这里看看有什么惊喜")
        
        setupUI()
        print(EmoticonManager.sharedManager)
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
        textView.text = "滑动隐藏键盘"
        
//        textView.snp.makeConstraints { (make) in
//            make.left.equalTo(tableView.snp.left)
//            make.right.equalTo(tableView.snp.right)
//            make.top.equalTo(-200)
//            make.height.equalTo(200)
//        }
        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
     }
}
