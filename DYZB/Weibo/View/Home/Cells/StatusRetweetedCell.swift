//
//  StatusRetweetedCell.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/3.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
// RetweetedCell
class StatusRetweetedCell: StatusCell {
    // 继承父类的属性：不需要super,先执行父类的didset,再执行子类的didset
       override var viewModel:StatusViewModel? {
            didSet {
                let text = viewModel?.retweetedText ?? ""
                
//              retweetedLabel.attributedText = viewModel?.retweetedText
                retweetedLabel.attributedText = EmoticonManager.sharedManager.emotionText(string: text, font: retweetedLabel.font)
                
                pictureView.snp.updateConstraints { (make) in
                    let count = viewModel?.thumbnailUrls?.count
                    let os = ((count ?? 0) > 0) ? StatusCellMargin : 0
                    make.top.equalTo(retweetedLabel.snp.bottom).offset(os)
                }
            }
        }
    
    private lazy var backButtom:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        return btn
    }()
    
    private lazy var retweetedLabel:UILabel = UILabel(title: "转发微博", fontSize:14.0, color: UIColor.darkGray, screenInset: StatusCellMargin)
    
    
    override func awakeFromNib() {super.awakeFromNib() }
    override func setSelected(_ selected: Bool, animated: Bool) {super.setSelected(selected, animated: animated)}
}

extension StatusRetweetedCell {
    override func setupUI() {
        super.setupUI()
        
        contentView.insertSubview(backButtom, belowSubview:pictureView)
        contentView.insertSubview(retweetedLabel,aboveSubview: backButtom)
        
        backButtom.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        retweetedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backButtom.snp.top).offset(StatusCellMargin)
            make.left.equalTo(backButtom.snp.left).offset(StatusCellMargin)
        }
        
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(retweetedLabel.snp.left)
            make.height.equalTo(90)
            make.width.equalTo(300)
        }
    }
}
