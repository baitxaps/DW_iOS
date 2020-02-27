//
//  StatusPictureView.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/2.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
import Kingfisher

private let StatusPictureViewItemMargin :CGFloat = 6
private let StatusPictureCellId = "StatusPictureCellId"

class StatusPictureView: UICollectionView {
    //MARK:- viewModel
    var viewModel:StatusViewModel? {
        didSet {
            sizeToFit()
            reloadData()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return calcViewSize()
    }
    
    //MARK: - init
    init() {
        let layout = UICollectionViewFlowLayout()
         // default itemSize 50*50
        layout.minimumLineSpacing = StatusPictureViewItemMargin
        layout.minimumInteritemSpacing = StatusPictureViewItemMargin
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        dataSource = self
      //  delegate = self
        register(StatusPictureViewCell.self, forCellWithReuseIdentifier: StatusPictureCellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatusPictureView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//      return viewModel?.thumbnailUrls?.count ?? 0
        guard let count = viewModel?.thumbnailUrls?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusPictureCellId, for: indexPath) as! StatusPictureViewCell
        cell.imageURL = viewModel?.thumbnailUrls![indexPath.row]
        return cell
    }
}


private class StatusPictureViewCell:UICollectionViewCell {
    var imageURL:URL? {
        didSet {
            iconView.kf.setImage(with: imageURL, placeholder:nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
        }
    }
    
    private lazy var iconView:UIImageView = {
        var iv = UIImageView();
        iv.layer.masksToBounds = true;
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        return iv
    }()
}

extension StatusPictureView {
    private func calcViewSize() -> CGSize {
        
        // 每行照片数量
        let rowCount:CGFloat = 3
        // 最大宽度
        let maxWidth = kScreenW - 2 * StatusCellMargin
        let itemWidth = (maxWidth - 2 * StatusPictureViewItemMargin) / rowCount
        
        // itemsize
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let count = viewModel?.thumbnailUrls?.count ?? 0
        if count == 0 {
            return CGSize.zero
        }
        
        if count == 1 {
            var size = CGSize(width: 150, height: 120)
            
            guard let url = viewModel?.thumbnailUrls?.first?.absoluteURL else {return size  }
            guard let key = url.absoluteString.removingPercentEncoding else {return size }
            guard let image =
                KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: key) else {
                return size
            }
            size = image.size
            
            // 过窄处理，针对长图
            size.width = size.width < 40 ? 40 :size.width
            //过宽的图片
            if size.width > 300 {
                //高等比缩放: h/w = heith/width
                let w:CGFloat = 300
                let h = size.height * CGFloat(w) / size.width
                size = CGSize(width:w, height: h)
            }
            
            layout.itemSize = size
            return size
        }
        
        // 2*2
        if count == 4 {
            let w = 2 * itemWidth + StatusPictureViewItemMargin
            return CGSize(width: w, height: w)
        }
        
        /*
         九宫格显示,row计算行数
         2 3
         5 6
         7 8 9
         */
        let row = CGFloat((count - 1) / Int(rowCount) + 1)
        let h  = row * itemWidth + (row - 1) * StatusPictureViewItemMargin
        let w = rowCount * itemWidth + (rowCount - 1) * StatusPictureViewItemMargin
        return CGSize(width: w, height: h)
    }
}
