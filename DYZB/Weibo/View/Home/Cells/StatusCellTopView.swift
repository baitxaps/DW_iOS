//
//  StatusCellTopView.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/1.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
import QorumLogs

class StatusCellTopView: UIView {
    var viewModel:StatusViewModel? {
        didSet {
            nameLabel.text = viewModel?.status.user?.screen_name
            
            iconView.kf.setImage(with: viewModel?.userProfileUrl, placeholder: viewModel?.userDefaultIconView)
            memberIconView.image = viewModel?.userMemberImage
            vipIconView.image = viewModel?.userVipImage
            
            timeLabel.text = viewModel?.status.created_at
            QL1(viewModel?.status.created_at)
            
            sourceLabel.text = viewModel?.status.source
        }
    }
    
    //MARK:-Init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var line:UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
    private lazy var iconView:UIImageView = UIImageView(imageName: "avatar_default_big")
    private lazy var sourceLabel:UILabel = UILabel(title: "source", fontSize: 11)
    private lazy var nameLabel:UILabel = UILabel(title: "name", fontSize: 14)
    private lazy var timeLabel:UILabel = UILabel(title: "time", fontSize: 11,color: UIColor.orange)
    private lazy var memberIconView:UIImageView = UIImageView(imageName: "common_icon_membership_level1")
    private lazy var vipIconView:UIImageView = UIImageView(imageName: "avatar_vip")
}

extension StatusCellTopView {
    private func setupUI() {
        backgroundColor = UIColor.white
        
        // sep line
        addSubview(line)
        // subviews
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(memberIconView)
        addSubview(vipIconView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(StatusCellMargin)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(StatusCellMargin)
            make.top.equalTo(line.snp.bottom).offset(StatusCellMargin)
            make.height.width.equalTo(StatusCellIconWidth)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
            make.top.equalTo(iconView.snp.top)
        }
        
        memberIconView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(StatusCellMargin)
            make.top.equalTo(nameLabel.snp.top)
        }
        
        vipIconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.right)
            make.centerY.equalTo(iconView.snp.bottom)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView.snp.bottom)
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargin)
        }
        
        sourceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(timeLabel.snp.bottom)
            make.left.equalTo(timeLabel.snp.right).offset(StatusCellMargin)
        }
    }
}










