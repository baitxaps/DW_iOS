//
//  PicturePickerController.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/24.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

private let PicturePickerCellId = "PicturePickerCellId"
private let picturePickerMaxCount  = 8

class PicturePickerController: UICollectionViewController {
    lazy var pictures = [UIImage]()
    private var selectedIndex = 0
    init() {
        super.init(collectionViewLayout:PicturePickerLayout())
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(PicturePickerCell.self, forCellWithReuseIdentifier: PicturePickerCellId)
    }
    
    // 没有布局默认 50*50。
    // 类中类
    private class PicturePickerLayout:UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            
            // 分辨率: iPhone 6s-:2   ,iPhone 6s+ :3
            // margin:iPhone 6s:8 ,iPhone 6s+ :12
            let margin = UIScreen.main.scale * 4
            let count:CGFloat = 4
            
            // (count + 1) * margin : 总共边距
            let w = (collectionView!.bounds.width - (count + 1) * margin) / count
            itemSize = CGSize(width: w, height: w)
            
            sectionInset = UIEdgeInsets(top: margin,left: margin,bottom: 0,right: margin)
            minimumLineSpacing = margin
            minimumInteritemSpacing = margin
        }
    }
}


extension PicturePickerController  {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count + (pictures.count == picturePickerMaxCount ? 0 : 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturePickerCellId, for: indexPath) as! PicturePickerCell
       // cell.backgroundColor = UIColor.red
        cell.pictureDelegate = self
        cell.image = indexPath.item < pictures.count ?  pictures[indexPath.item]:nil
        return cell
    }
}

// MARK:- PicturePickerCellDelegate
extension PicturePickerController:PicturePickerCellDelegate {
    fileprivate func picturePickerCellDidAdd(cell:PicturePickerCell) {
        print("DidAdd.");
        // photoLibrary 保存的照片（可以删除） + 同步的照片（不充许删除）
        // SavedPhotosAlbum 保存的照片/屏幕截图/拍照
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("no access the photoLibrary")
            return
        }
        
        selectedIndex = collectionView.indexPath(for: cell)?.item ?? 0
        
        let picker = UIImagePickerController()
        picker.delegate = self
    // picker.allowsEditing  = true
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    fileprivate func picturePickerCellDidRemove(cell:PicturePickerCell) {
        print("DidRemove.");
        let indexPath = collectionView!.indexPath(for: cell)!
        if indexPath.item >= pictures.count {
            return
        }
        
        pictures.remove(at: indexPath.item)
        //collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
}


@objc
private protocol PicturePickerCellDelegate:NSObjectProtocol {
  @objc optional func picturePickerCellDidAdd(cell:PicturePickerCell)
  @objc optional func picturePickerCellDidRemove(cell:PicturePickerCell)
}


// MARK:-UIImagePickerControllerDelegate /
extension PicturePickerController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         print(info)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // 控制内存
        // 一般在100M 左右，再高就要水注言意了
        let scaleImage = image.scalcToWith(width: 600)
        
        if selectedIndex >= pictures.count {
            pictures.append(scaleImage)
        }else {
           pictures[selectedIndex] = scaleImage
        }
       
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true, completion: nil)
    }
}

// MARK:-Cell
private  class PicturePickerCell:UICollectionViewCell {
    weak var pictureDelegate:PicturePickerCellDelegate?
    
    var image:UIImage? {
        didSet {
            addBtn.setImage(image ?? UIImage(named: "compose_pic_add"), for: .normal)
            removeBtn.isHidden = (image == nil)
        }
    }
    
    @objc func addPicture() {
        pictureDelegate?.picturePickerCellDidAdd?(cell: self)
    }
    
    @objc func removepicture() {
        pictureDelegate?.picturePickerCellDidRemove?(cell: self)
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(addBtn)
        contentView.addSubview(removeBtn)
        addBtn.frame = bounds
        addBtn.imageView?.contentMode = .scaleAspectFill
        addBtn.addTarget(self, action: #selector(addPicture), for: .touchUpInside)
        removeBtn.addTarget(self, action: #selector(removepicture), for: .touchUpInside)
        
        removeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right)
        }
    }
    
    private lazy var addBtn:UIButton = UIButton(imageName: "compose_pic_add", backImageName: nil)
    private lazy var removeBtn:UIButton = UIButton(imageName: "compose_photo_close", backImageName: nil)
}




