//
//  VisitorView.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/16.
//  Copyright © 2020 @huse.cn. All rights reserved.~Vs059581004

import UIKit
import SnapKit

protocol VisitorViewDelegate:NSObjectProtocol {
    func visitorViewDidRegister()
    func visitorViewDidLogin()
}

class VisitorView: UIView {
   // MARK:- delegate
    weak var delegate:VisitorViewDelegate?
    
    @objc private func clickLogin() {
        delegate?.visitorViewDidLogin()
    }
    
    @objc private func clickRegister() {
        delegate?.visitorViewDidRegister()
    }
    
    func setupInfo(imageName:String?,title:String) {
        messageLabel.text = title
        guard let imgName = imageName else {
            startAnim()
            return
        }
        iconView.image = UIImage(named: imgName)
        homeIconView.isHidden = true
        
        // maskIconView 移动到底层
        sendSubviewToBack(maskIconView)
    }
    
    // MARK:- animation
    private func startAnim() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2*Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 20
        //background,
        anim.isRemovedOnCompletion = false//不断重复的动画上,绑定的视被销毁，动画会自动销毁
        iconView.layer.add(anim,forKey: nil)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
       // fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        setupUI()
    }
    
    private lazy var iconView:UIImageView = UIImageView(imageName: "visitordiscover_feed_image_smallicon")
    
    private lazy var maskIconView:UIImageView = UIImageView(imageName: "visitordiscover_feed_mask_smallicon")
    
    private lazy var homeIconView :UIImageView = UIImageView(imageName:  "visitordiscover_feed_image_house")
    
    private lazy var messageLabel:UILabel = UILabel(title: "关注一些人，回这里看看有什么惊喜")
    
    private lazy var reginsterButton:UIButton = UIButton(title: "注册", color: UIColor.orange, imageName: "common_button_white_disable")
    
    private lazy var loginButton:UIButton = UIButton(title:"登录", color: UIColor.darkGray, imageName: "common_button_white_disable")

}

// 扩展中不能定义存储属性，只许写便得构造水函数，而不能写指定构造函数
extension VisitorView {
    private func setupUI() {
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(homeIconView)
        addSubview(messageLabel)
        addSubview(reginsterButton)
        addSubview(loginButton)
        
        backgroundColor = UIColor(white: 237/255.0, alpha: 1.0)
        loginButton.addTarget(self, action: #selector(clickLogin),for: .touchUpInside)
        reginsterButton.addTarget(self, action: #selector(clickRegister),for: .touchUpInside)
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY).offset(-60)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        maskIconView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(reginsterButton.snp.bottom)
        }
        
        homeIconView.snp.makeConstraints { (make) in
            make.center.equalTo(iconView.snp.center)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.centerX)
            make.top.equalTo(iconView.snp.bottom).offset(15)
            make.width.equalTo(224)
            make.height.equalTo(36)
        }
        
        reginsterButton.snp.makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.left.equalTo(messageLabel.snp.left)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(reginsterButton.snp.top)
            make.right.equalTo(messageLabel.snp.right)
            make.width.equalTo(reginsterButton.snp.width)
            make.height.equalTo(reginsterButton.snp.height)
         }
    }
}


/*
  iconView.translatesAutoresizingMaskIntoConstraints = false
  addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
  addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
 
 // 6> 遮罩图像
  // views: 定义 VFL 中的控件名称和实际名称映射关系
  // metrics: 定义 VFL 中 () 指定的常数影射关系
  let viewDict = ["maskIconView": maskIconView,
                  "registerButton": registerButton]
  let metrics = ["spacing": 20]
  
  addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[maskIconView]-0-|",
      options: [],
      metrics: nil,
      views: viewDict))
  addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
      options: [],
      metrics: metrics,
      views: viewDict))
*/
