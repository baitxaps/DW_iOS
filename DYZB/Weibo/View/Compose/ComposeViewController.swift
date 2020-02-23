//
//  ComposeViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/23.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    private lazy var emoticonView:EmoticonView = EmoticonView {[weak self](emotion) in
//      self?.insertEmoticon(em: emotion)
        self?.textView.insertImageEmoticon(em: emotion)
    }
        
    
    @objc private func close() {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    
    //{"error":"Insufficient app permissions!","error_code":10014,request = "/2/statuses/update.json"}
    //https://jingyan.baidu.com/article/fdffd1f8384e28f3e98ca1f0.html
    
    @objc private func sendStatus() {
        print("send msg")
        let text = textView.emotinText
    
        ComposeViewModel.postStatus(status: text, image: nil) { (response, error) in
            print(response)
            
            guard let response = response as? [String : AnyObject] else {return}
            
            let error = (response["error"]) as! String
            if error.caseInsensitiveCompare("expired_token").rawValue == 0 {
                print("expired_token")
            }
          
        }
    }
    
    @objc private func selectEmoticon() {
        print("selectEmoticon\(String(describing: textView.inputView))")
        
        textView.resignFirstResponder()
        // 如果是使用的是系统键盘，是nil
        textView.inputView = textView.inputView == nil ?  emoticonView :nil
        textView.becomeFirstResponder()
     }
    
    @objc private func keyboardChange(n:NSNotification) {
       print(n)
        // struct : NSValue
        let rect = (n.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(rect)
        
        // animated duration
        let duration = (n.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        print(duration)
        
        // animated curve
        let curve = (n.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        
        let offset = -UIScreen.main.bounds.height + rect.origin.y
        toolbar.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(offset)//-rect.height
        }
        
        UIView.animate(withDuration: duration) {//CAAnimation 包装
            // 曲线值 = 7
            // 如果之前的动画没有完成，有启动了其他的动田画，让动画的图层直执着运到到后续动画的目标位置
            // 一旦设置了 7，动画时长无效,动画时长统一变成0.5s
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue:curve)!)
            self.view.layoutIfNeeded()
        }
        
      //  let anim = toolbar.layer.animation(forKey: "position")
      //  print("animted:\(anim?.duration)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange),name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    override func loadView() {
        view = UIView()
        setupUI()
    }

    private lazy var toolbar = UIToolbar()
    
    private lazy var textView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = UIColor.darkGray
        tv.alwaysBounceVertical = true
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    private lazy var placeHolderLabel = UILabel(title: "分享新鲜事...", fontSize: 18, color: UIColor.lightGray)
}

// MARK: - setupUI
private extension ComposeViewController {
    func setupUI() {
        view.backgroundColor = UIColor.white
        
        prepareNavigationBar()
        prepareToolbar()
        preparetextView()
    }
    
    private func preparetextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.bottom.equalTo(toolbar.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.topMargin)
        }
        textView.text = "分享新鲜事..."
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.top).offset(8)
            make.left.equalTo(textView.snp.left).offset(5)
        }
    }
    
    private func prepareToolbar() {
        view.addSubview(toolbar)
        toolbar.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        toolbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-safeBottomHeight())
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(44)
        }
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "selectEmoticon"],
                            ["imageName": "compose_add_background"]]
        
        var items = [UIBarButtonItem]()
        for dict in itemSettings {
            items.append(UIBarButtonItem(image: dict["imageName"]!,target: self,
            actionName: dict["actionName"]))
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
    }
    
   private func prepareNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(close));
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(sendStatus));
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        navigationItem.titleView = titleView
        
        let titleLabel = UILabel(title: "发微博", fontSize: 15)
        let nameLabel = UILabel(title: UserAccountViewModel.shared.account?.screen_name ?? "", fontSize: 13, color: UIColor.lightGray)
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(nameLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.snp.centerX)
            make.top.equalTo(titleView.snp.top)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleView.snp.centerX)
            make.bottom.equalTo(titleView.snp.bottom)
        }
    }
}
