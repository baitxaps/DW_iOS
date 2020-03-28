//
//  StatusNormalCell.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/3.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
// 原创Cell
class StatusNormalCell: StatusCell {
    // 继承父类的属性：不需要super,先执行父类的didset,再执行子类的didset
       override var viewModel:StatusViewModel? {
            didSet {
                pictureView.snp.updateConstraints { (make) in
                    let count = viewModel?.thumbnailUrls?.count
                    let os = ((count ?? 0) > 0) ? StatusCellMargin : 0
                    make.top.equalTo(contentLabel.snp.bottom).offset(os)
                }
            }
        }
    
    override func setupUI() {
        super.setupUI()
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentLabel.snp.left)
            make.height.equalTo(90)
            make.width.equalTo(300)
        }
    }

    override func awakeFromNib() {super.awakeFromNib()}
    override func setSelected(_ selected: Bool, animated: Bool) { super.setSelected(selected, animated: animated)}
}
