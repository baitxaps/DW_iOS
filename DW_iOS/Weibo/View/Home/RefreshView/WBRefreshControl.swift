//
//  WBRefreshControl.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/2/4.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
private let WBRefreshControlOffset:CGFloat = -60

class WBRefreshControl: UIRefreshControl {
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopAnimation()
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshView.startAnimation()
    }
    /*
     1.始终待在屏幕上
     2.下拉的时候，frame的y一直变小，相反（向下推）一直变大
     3.默就的y是0
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if frame.origin.y > 0 {
            return
        }
        
        if isRefreshing {
            refreshView.startAnimation()
            return
        }
        
        if frame.origin.y < WBRefreshControlOffset && !refreshView.rotateFlag {
            refreshView.rotateFlag = true
            print("反过来")
        }else if frame.origin.y >= WBRefreshControlOffset && refreshView.rotateFlag {
            refreshView.rotateFlag  = false
            print("转过去")
        }
        
       // print(frame)
    }
    
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tintColor = UIColor.clear
        setupUI()
    }
    
    private func setupUI() {
        addSubview(refreshView)

        // 当主线程有任务，就不调度队列中的任务执行
        // 让当前运行循环中所有代码执行完毕后，运行循环结束前，开始监听
        // 方法触发会在下一次运行循环开始
        DispatchQueue.main.async(execute: {
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        })

        // 自动布局从xib 加载的控件需要指定大小约束
        refreshView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(refreshView.bounds.size)
        }
    }
    
    deinit{
        self.removeObserver(self, forKeyPath: "frame")
    }

    private lazy var refreshView = WBRefreshView.refreshView()
}

class WBRefreshView:UIView {
    fileprivate var rotateFlag = false {
        didSet {
            rotateTipIcon()
        }
    }
    
    @IBOutlet weak var tipIconView: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var loadingIconView: UIImageView!
    
    class  func refreshView()-> WBRefreshView {
        let nib = UINib(nibName: "WBRefreshView", bundle: nil)
        return nib.instantiate(withOwner:nil, options:nil)[0] as! WBRefreshView
    }
    
    private func rotateTipIcon() {
        var angle = CGFloat(Double.pi)
        angle += rotateFlag ? -0.0000001 : 0.0000001
        
        // 旋转动画，顺时针优先+ 就近原则
        UIView.animate(withDuration: 0.5) {
            self.tipIconView.transform = self.tipIconView.transform.rotated(by:angle)
        }
    }
    
    fileprivate func startAnimation() {
        tipView.isHidden = false
        
        let key = "transform.rotation"
        if loadingIconView.layer.animation(forKey: key) != nil {
            return
        }
        
        let anim = CABasicAnimation(keyPath: key)
        anim.toValue = 2*Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 0.5
        anim.isRemovedOnCompletion = false
        loadingIconView.layer.add(anim,forKey: key)
    }
    
    fileprivate func stopAnimation() {
        tipView.isHidden = true
        loadingIconView.layer.removeAllAnimations()
    }
}
