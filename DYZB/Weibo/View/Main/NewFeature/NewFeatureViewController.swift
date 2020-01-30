//
//  NewFeatureViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/20.
//  Copyright © 2020 @huse.cn. All rights reserved.
//  

import UIKit

private let WBNewFeatureViewCellId = "WBNewFeatureViewCellId"
private let WBNewFeatureImageCount = 4

class NewFeatureViewController: UICollectionViewController {
    // 懒加载属性，必须要在控制器实例化之后才会被创建
    // private lazy var layout = UICollectionViewFlowLayout()
    
    // MARK:- init, must be layout
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        super.init(collectionViewLayout: layout)
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prefersStatusBarHidden() ->Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(NewFeatureCell.self, forCellWithReuseIdentifier: WBNewFeatureViewCellId)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WBNewFeatureImageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WBNewFeatureViewCellId, for: indexPath)as! NewFeatureCell

        cell.imageIndex = indexPath.item
        return cell
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if page != WBNewFeatureImageCount - 1 {
            return
        }
        let cell = collectionView?.cellForItem(at:IndexPath(item:page,section:0)) as!NewFeatureCell
        
        cell.showButtonAnim()
    }
}


private class NewFeatureCell:UICollectionViewCell {
     var imageIndex :Int = 0 {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex+1)")
            startButton.isHidden = true
        }
    }
    
    @objc private func clickStartButton() {
        
    }
    
    fileprivate func showButtonAnim() {
        startButton.isHidden = false
        startButton.isUserInteractionEnabled = false
        startButton.transform = CGAffineTransform(scaleX: 0,y: 0)
        UIView.animate(withDuration: 1.6,//动画时长
            delay:0,         //延时时间
            usingSpringWithDamping: 0.6,//弹力系数，0～1，越小越弹
            initialSpringVelocity: 10,  //初始速度，模拟重力加速度
            options:[] ,         //动画选项
            animations: {()->Void in
                self.startButton.transform = CGAffineTransform.identity
        }) { (Bool)->Void in
            print("OK")
            self.startButton.isUserInteractionEnabled = true
        }
    }
    
    // frame 的大小是layout.itemsize指定的
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(iconView)
        addSubview(startButton)
        iconView.frame = bounds
        
        startButton.addTarget(self, action: #selector(clickStartButton), for: .touchUpInside)
        
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.7)//multipliedBy read only.不能更新
        }
    }
    
    private lazy var startButton:UIButton = UIButton(title: "开始体验", color:UIColor.white, imageName: "new_feature_finish_button")
    
    
    private lazy var iconView:UIImageView = UIImageView()
}



























