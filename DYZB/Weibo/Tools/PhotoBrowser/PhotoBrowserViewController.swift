//
//  PhotoBrowserViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/27.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
private let PhotoBrowserViewCellId = "PhotoBrowserViewCellId"

class PhotoBrowserViewController: UIViewController {
    @objc private func close(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func save() {
        print("save")
    }
    
    init(urls:[URL],indexPath:NSIndexPath) {
        self.urls = urls
        self.currentIndexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        var rect = UIScreen.main.bounds
        // 产生间距
        rect.size.width += 20
        view = UIView(frame: rect)
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setupUI()
    }
    
    private var urls:[URL]
    private var currentIndexPath:NSIndexPath
    
    private lazy var collectionView :UICollectionView = UICollectionView (frame:CGRect.zero,collectionViewLayout: PhotoBrowserViewLayout())
    private lazy var closeBtn :UIButton = UIButton(title: "关闭", fontSize: 14, color: UIColor.white, imageName:nil, backColor: UIColor.darkGray)
    
    private lazy var saveBtn :UIButton = UIButton(title: "保存", fontSize: 14, color: UIColor.white, imageName:nil, backColor: UIColor.darkGray)
    
    private class PhotoBrowserViewLayout:UICollectionViewFlowLayout {
         override func prepare() {
            super.prepare()
            itemSize = collectionView!.bounds.size
            
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}


private extension PhotoBrowserViewController {
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-(8 + safeBottomHeight()))
            make.left.equalTo(view.snp.left).offset(8)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-(8 + safeBottomHeight()))
            make.right.equalTo(view.snp.right).offset(-8)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        prepareCollectionView()
    }
    
    private func prepareCollectionView() {
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowserViewCellId)
        collectionView.dataSource = self
    }
}

extension PhotoBrowserViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserViewCellId, for: indexPath) as! PhotoBrowserCell
        cell.backgroundColor = UIColor.black
        cell.imageURL = urls[indexPath.item]
        return cell
    }
}

















