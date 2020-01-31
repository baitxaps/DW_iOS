//
//  UIView+indicatorView.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/31.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension NVActivityIndicatorView {
    convenience init(type:NVActivityIndicatorType? = .ballSpinFadeLoader, color:UIColor? = UIColor.black,padding: CGFloat? = nil) {
        
        let frame = CGRect(
                x: kScreenW/2.0-kIndicator/2.0,
                y: kScreenH/2.0-kIndicator/2.0,
            width: kIndicator,
            height: kIndicator)

        self.init(frame: frame, type: .ballSpinFadeLoader,color: UIColor.black)
    }
}

