//
//  StatusCellBottomView.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/1.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class StatusCellBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var retweetedButton:UIButton = UIButton(title: " 转发", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_retweet")

      private lazy var commentButton:UIButton = UIButton(title: " 评论", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_comment")
    
      private lazy var likeButton:UIButton = UIButton(title: " 转发", fontSize: 12, color: UIColor.darkGray, imageName: "timeline_icon_unlike")
}

extension StatusCellBottomView {
    private func setupUI() {
        backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        addSubview(retweetedButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        retweetedButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.left.equalTo(retweetedButton.snp.right)
            make.top.equalTo(retweetedButton.snp.top)
            make.width.equalTo(retweetedButton.snp.width)
            make.height.equalTo(retweetedButton.snp.height)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.left.equalTo(commentButton.snp.right)
            make.top.equalTo(commentButton.snp.top)
            make.width.equalTo(commentButton.snp.width)
            make.height.equalTo(commentButton.snp.height)
            make.right.equalTo(self.snp.right)
        }
        
        let leftLine = setupLine()
        let rightLine = setupLine()
        addSubview(leftLine)
        addSubview(rightLine)
        
        let w = 0.5
        let h = 0.4
        
        leftLine.snp.makeConstraints { (make) in
            make.left.equalTo(retweetedButton.snp.right)
            make.centerY.equalTo(commentButton.snp.centerY)
            make.width.equalTo(w)
            make.height.equalTo(commentButton.snp.height).multipliedBy(h)
        }
        
        rightLine.snp.makeConstraints { (make) in
            make.left.equalTo(commentButton.snp.right)
            make.centerY.equalTo(commentButton.snp.centerY)
            make.width.equalTo(w)
            make.height.equalTo(commentButton.snp.height).multipliedBy(h)
        }
    }
    
    private func setupLine()->UIView {
        let v:UIView = UIView()
        v.backgroundColor = UIColor.darkGray
        return v
    }
}
