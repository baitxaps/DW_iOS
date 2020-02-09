//
//  EmojiIconView.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/5.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

private let EmoticonViewCellId = "EmoticonViewCellId"

class EmoticonView: UIView {
    
    private var selectedEmoticonCallBack:(_ emoticon:Emoticon)->()
    
    @objc func clickItem(item:UIBarButtonItem) {
        print(item.tag)
        let indexPath = NSIndexPath(item:0,section:item.tag)
        collectionView.scrollToItem(at:indexPath as IndexPath, at: .left, animated: true)
    }
    
    init(selectedEmoticon:@escaping (_:Emoticon)->()) {
        
        selectedEmoticonCallBack = selectedEmoticon
        
        var rect = UIScreen.main.bounds
        rect.size.height = 226 + safeBottomHeight()//216
        super.init(frame:rect)
        
        setupUI()
        
        let indexPath = NSIndexPath(item:0,section:1)
        delay(delta: 0.3) {
            self.collectionView.scrollToItem(at:indexPath as IndexPath, at: .left, animated: false)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var packages = EmoticonManager.sharedManager.packages
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout:EmoticonLayout())
    
    private lazy var toolbar = UIToolbar()
    
    // MARK:- 类中类，只允被包含的类使用
    private class EmoticonLayout:UICollectionViewFlowLayout {
        /*private override func prepare()
         error: Overriding property must be as accessible as its enclosing type
         collectionView第一次布局时候被自动调用
         collectionView的Size已经设置好
         */
         override func prepare() {
            super.prepare()
            
            let col :CGFloat = 7
            let row :CGFloat = 3
            let w :CGFloat = (collectionView!.bounds.width ) / col
            let margin:CGFloat = (collectionView!.bounds.height - row * w ) * 0.499
            
            itemSize = CGSize(width: w, height: w)
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
            
            scrollDirection = .horizontal
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}

private extension EmoticonView {
    private func setupUI() {
        backgroundColor = UIColor.white
        addSubview(toolbar)
        addSubview(collectionView)
        
        toolbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-safeBottomHeight())
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(toolbar.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
        }
        
        prepareToolbar()
        
        perpareCollectionView()
    }
    
    private func prepareToolbar() {
        toolbar.layoutIfNeeded()
        
        toolbar.tintColor = UIColor.darkGray
        var items:[UIBarButtonItem] = [UIBarButtonItem]()
        var index = 0
        for title in packages {
            items.append(UIBarButtonItem(title: title.groupName, style: .plain, target:self, action: #selector(clickItem)))
            items.last?.tag = index
            index = index + 1

            items.append(UIBarButtonItem(barButtonSystemItem:.flexibleSpace,target: nil, action: nil))
        }
        items.removeLast()
        
        toolbar.items = items
    }
    
    private func perpareCollectionView() {
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonViewCellId)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK:- UICollectionViewDataSource
extension EmoticonView:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonViewCellId, for: indexPath) as! EmoticonViewCell
        cell.emotion = packages[indexPath.section].emoticons[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let em = packages[indexPath.section].emoticons[indexPath.item]
        
        selectedEmoticonCallBack(em)
    }
}

private class EmoticonViewCell :UICollectionViewCell {
    var emotion:Emoticon? {
        didSet {
            emoticonButton.setImage(UIImage(contentsOfFile: emotion!.imagePath), for:.normal)
            emoticonButton.setTitle(emotion?.emoji, for: .normal)
            
            if emotion!.isRemoved {
                emoticonButton.setImage(UIImage(contentsOfFile: emotion!.deleteImagePath), for:.normal)
            }
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        contentView.addSubview(emoticonButton)
        emoticonButton.frame = bounds.insetBy(dx: 4,dy: 4)
        emoticonButton.backgroundColor = UIColor.white
        emoticonButton.setTitleColor(UIColor.black, for:.normal)
        emoticonButton.isUserInteractionEnabled = false
        // font 的大小和高度相近
        emoticonButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        print(frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate lazy var emoticonButton:UIButton = UIButton()
}















