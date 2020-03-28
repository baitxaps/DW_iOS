//
//  StatusCell.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/2/1.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
import FFLabel
import QorumLogs

let StatusCellMargin:CGFloat = 12
let StatusCellIconWidth:CGFloat = 35

protocol StatusCellDelegate:NSObjectProtocol {
    func statusCellDidClickUrl(url:URL)
}

// weibo cell
class StatusCell: UITableViewCell {
    // Clicked  the URL
    weak var cellDelegate:StatusCellDelegate?
    
    //MARK:- viewModel
    var viewModel:StatusViewModel? {
        didSet {
            topView.viewModel = viewModel
           
            let text = viewModel?.status.text ?? ""
            
            contentLabel.attributedText = EmoticonManager.sharedManager.emotionText(string: text, font: contentLabel.font)
            
            pictureView.viewModel = viewModel
            
            pictureView.snp.updateConstraints { (make) in
                make.height.equalTo(pictureView.bounds.height)
                make.width.equalTo(pictureView.bounds.width)
            }
        }
    }

    func rowHeight(vm:StatusViewModel) -> CGFloat {
        viewModel = vm
        
        contentView.layoutIfNeeded()
        
        //CGRectGetMaxY(bottomView.frame)
        return bottomView.frame.maxY
    }
    
    //MARK:- init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        setupUI()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var topView : StatusCellTopView = StatusCellTopView()
    
    lazy var contentLabel :FFLabel = FFLabel(title: "微博正文", fontSize: 15 ,color: UIColor.darkGray,screenInset: StatusCellMargin)

    lazy var pictureView:StatusPictureView = StatusPictureView()
    
    lazy var bottomView:StatusCellBottomView = StatusCellBottomView()
    
    
    override func awakeFromNib() { super.awakeFromNib() }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)}
}

extension StatusCell {
    @objc func setupUI() {
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        contentLabel.labelDelegate = self 
        
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(2 * StatusCellMargin + StatusCellIconWidth)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left).offset(StatusCellMargin)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(pictureView.snp.bottom).offset(StatusCellMargin)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)//make.bottom.equalTo(contentView.snp.bottom)
        }
    }
}


extension StatusCell: FFLabelDelegate {
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        QL2(text)
        
        if text.hasPrefix("http://") {
            guard let url = URL(string: text) else {return}
            
            cellDelegate?.statusCellDidClickUrl(url: url)
        }
    }
}













