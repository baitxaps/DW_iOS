//
//  ProgressImageView.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/2/28.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
// 在UIImageView 的drawRect 中绘图不会执行drawRect函数
class ProgressImageView: UIImageView {
    var progress:CGFloat = 0 {
        didSet {
            progressView.progress = progress
        }
    }
    
    init() {
        super.init(frame:CGRect.zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(progressView)
        progressView.backgroundColor = UIColor.clear
        
        progressView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
    }
    
    private lazy var progressView:ProgressView = ProgressView()
}


private class ProgressView:UIView {
    var progress:CGFloat = 0 {
        didSet {
           setNeedsDisplay()
        }
    }

     /*
      UIBezierPath:默认起始点在3点钟位置,顺时针12点开始位置: -2*pi
     */
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let r = min(rect.width,rect.height) * 0.5
        let start = CGFloat(-Double.pi / 2)
        let end = start + progress * 2 * CGFloat(Double.pi) // 2*pi*r
        print("progress:\(progress)")
        let path = UIBezierPath(arcCenter: center, radius: r, startAngle: start, endAngle: end, clockwise: true)// 是否顺时针
        
        // 添加到中心点田连线,形成一个线形,(否则进度0.25太小，是一条圆弧线)
        path.addLine(to: center)
        path.close()
        UIColor(white: 1, alpha: 0.3).setFill()
        path.fill()
        
//        let path = UIBezierPath(ovalIn: rect)
//        UIColor.red.setFill()
//        path.fill()
    }
}













