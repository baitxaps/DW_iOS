//
//  PhotoBrowserCell.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/27.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

class PhotoBrowserCell: UICollectionViewCell {
    var imageURL:URL? {
        didSet {
//            KingfisherManager.shared.downloader.downloadImage(with:imageURL ?? URL(string: "")!, options:[]) { (result) in
//            }
            guard let imageURL = imageURL else {
                return
            }
            
            resetScrollView()
            
            // thumbnail
            imageView.image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: imageURL.absoluteString)
            imageView.sizeToFit()
            imageView.center = scrollView.center
            
            // thumbnail
            // 清除之前的图片/如果之前图片也是异步下载，但时没有完成，取消之前的异步操作
            imageView.kf.setImage(with: bmiddleURL(url: imageURL), placeholder: nil, options: [], progressBlock: nil) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let response):
                    let image:UIImage? = response.image
                    self.setPositon(image: image!)
                }
            }
        }
    }
    
    private func resetScrollView() {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
    }
    
    // 长短图的显示
    private func setPositon(image:UIImage) {
    // self.imageView.sizeToFit()
    // self.imageView.center = CGPoint.zero
        let size = self.displaySize(image:image)
        // 小图上下居中
        if size.height < scrollView.bounds.height {
            /*
            let y = (scrollView.bounds.height - size.height) * 0.5
            imageView.frame = CGRect(x: 0, y: y, width: size.width, height: size.height)
           */
            
            // 调整frame 的x/y，一旦缩放，影响滚动范围
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            // 内容边距，会调整控件位置，但是不会影响控件的滚动
            let y = (scrollView.bounds.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
            
        }else {
           // 长图
            imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            scrollView.contentSize = size
        }
    }
    
    private func bmiddleURL(url:URL)->URL {
        print(url)
        var urlString = url.absoluteString
        
        urlString = urlString.replacingOccurrences(of:"/thumbnail/", with:"/bmiddle/", options: .literal, range: nil)
        return URL(string: urlString)!
    }

    // 根据scrollView的宽度 计算等比例缩放之后的图片尺寸
    private func displaySize(image:UIImage) ->CGSize {
        let w = scrollView.bounds.width
        let h = image.size.height * w / image.size.width
        
        return CGSize(width: w, height: h)
    }
        
    override init(frame:CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
       
        // 拖动有一个间隔
        var r = bounds
        r.size.width -= 20
        scrollView.frame = r
        
        //ZoomScale
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
    }
    
    private lazy var scrollView:UIScrollView = UIScrollView()
    private lazy var imageView:UIImageView = UIImageView()
}

// MARK:- UIScrollViewDelegate
extension PhotoBrowserCell:UIScrollViewDelegate {
    // 返回被缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // 缩放完成后执行一次
    // UIView:被缩放的视图
    // scale被缩放的比例
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scale finished \(view!) \(view!.bounds)")
        var ofY = (scrollView.bounds.height - view!.frame.height) * 0.5
        var ofX = (scrollView.bounds.width - view!.frame.width) * 0.5
        
        // view.frame.height > scrollView.bounds.height 不能拉下来
        ofY = ofY < 0 ? 0 : ofY
        ofX = ofX < 0 ? 0 : ofX
        
        scrollView.contentInset = UIEdgeInsets(top: ofY, left: ofX, bottom: 0, right: 0)
    }
  
    /*
    struct CGAffineTransform {
      a,d 缩放比例
      CGFloat a, b, c, d; 共同决定旋转
      CGFloat tx, ty;设置位移
      
      frame = center + bounds(不会变) * transform
    };
 */
    // 只要缩放就会被调用
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(imageView.transform)
    }
}

















