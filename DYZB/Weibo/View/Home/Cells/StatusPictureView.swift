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
        backgroundColor = UIColor(white:1, alpha: 1.0)
        
        dataSource = self
        delegate = self
        register(StatusPictureViewCell.self, forCellWithReuseIdentifier: StatusPictureCellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatusPictureView:UICollectionViewDataSource ,UICollectionViewDelegate {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click\(indexPath.item)\(String(describing: viewModel?.thumbnailUrls))")
        
       // photoBrowserPresentFromRect(indexPath: indexPath as NSIndexPath)
       // photoBrowserPresentToRect(indexPath: indexPath as NSIndexPath)
      
        NotificationCenter.default.post(
                             name: Notification.Name(WBStatusSelectedPhotoNotification) ,
                             object:self,
                             userInfo: [WBStatusSelectedPhotoIndexPathKey: indexPath,WBStatusSelectedPhotoURLsKey:viewModel!.thumbnailUrls!])
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

// MARK:- PhotoBrowserPresentDelegate

extension StatusPictureView: PhotoBrowserPresentDelegate {
    // 指定indexPath 对应的imageVIew 用来做动画效果
    func imageViewForPresent(indexPath:NSIndexPath) -> UIImageView {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        if let url = viewModel?.thumbnailUrls?[indexPath.item] {
            iv.kf.setImage(with: url)
        }
        
        return iv
    }
     //动画转场的起始位置
    func photoBrowserPresentFromRect(indexPath:NSIndexPath) -> CGRect {
        let cell = self.cellForItem(at: indexPath as IndexPath)
        //print(cell!)
        
        // self.是cell的父视图
        // collectionView 将cell的 frame位置 转换的 keyWindow对应的 frame位置
        let rect = self.convert(cell!.frame, to: UIApplication.shared.keyWindow)
        
        // test
//        let v = UIView(frame: rect)
//        v.backgroundColor = UIColor.red
//        UIApplication.shared.keyWindow?.addSubview(v)
        
//        let v = imageViewForPresent(indexPath: indexPath)
//        v.frame = rect
//        UIApplication.shared.keyWindow?.addSubview(v)
        
        return rect
    }
     // 动画转场的目标位置
    func photoBrowserPresentToRect(indexPath:NSIndexPath) -> CGRect {
        guard let key = viewModel?.thumbnailUrls?[indexPath.item].absoluteString else {
            return CGRect.zero
        }
        
        guard let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: key) else {
            return CGRect.zero
        }
        
        // 根据图像大小，计算全屏的大小
        let w = UIScreen.main.bounds.width
        let h = image.size.height * w / image.size.width
        
        let screenHeight = UIScreen.main.bounds.height
        var y:CGFloat = 0
        if h < screenHeight { // 图片短，垂直居中显示
            y = (screenHeight - h ) * 0.5
        }
        
        let rect = CGRect(x: 0, y: y, width: w, height: h);

        // test
//        let v = imageViewForPresent(indexPath: indexPath)
//        v.frame = rect
//        UIApplication.shared.keyWindow?.addSubview(v)
        
      return rect
    }
}



















