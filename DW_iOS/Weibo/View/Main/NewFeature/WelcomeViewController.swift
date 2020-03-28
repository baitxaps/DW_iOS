//
//  WelcomeViewController.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/1/30.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
import Kingfisher

class WelcomeViewController: UIViewController {
    override func loadView() {
        view = backImageView
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        iconView.kf.setImage(with: UserAccountViewModel.shared.avatarUrl, placeholder: UIImage(named: "avatar_default_big"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        iconView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-view.bounds.height+200)
        }
        // multipliedBy 只读.不能更新
        // 所有使用约束，不要设置frame:系统会根据设置自动计算控件的frame,
        // 在layoutSubViews 中设置frame,引起自动布局系统计算错误:在运行循环结束前，调用layoutSubView函数统一设置frame
        welcomLabel.alpha = 0
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.8, animations: {
                self.welcomLabel.alpha = 1
            }) { (_) in
                NotificationCenter.default.post(name: NSNotification.Name( WBSwitchRootViewControllerNotification),object: nil)
            }
        }
    }
    
    private lazy var backImageView :UIImageView = UIImageView(imageName: "ad_background")
    private lazy var iconView:UIImageView = {
        let iv = UIImageView(imageName: "avatar_default_big")
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private lazy var welcomLabel:UILabel = UILabel(title: "欢迎归来", fontSize: 18)
}

// MARK:- setupUI

extension WelcomeViewController {
    private func setupUI() {
        view.addSubview(iconView)
        view.addSubview(welcomLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-200)
            make.width.height.equalTo(90)
        }
        
        welcomLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.centerX)
            make.top.equalTo(iconView.snp.bottom).offset(16)
        }
    }
}
