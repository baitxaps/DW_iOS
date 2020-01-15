//
//  CollectionCycleCell.swift
//  DYZB
//
//  Created by hairong chen on  9/21.
//  Copyright @huse.cn All rights reserved.
//
//xib:command += ,图片显示原来大小
import UIKit
import Kingfisher

class CollectionCycleCell: UICollectionViewCell {
    
    // MARK: 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: 定义模型属性
    var cycleModel : CycleModel? {
        didSet {
            titleLabel.text = cycleModel?.title
            if let iconURL = URL(string: cycleModel?.pic_url ?? "") {
                iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "Img_default"))
            }else {
                iconImageView.image = UIImage(named: "Img_default")
            }
        }
    }
}
