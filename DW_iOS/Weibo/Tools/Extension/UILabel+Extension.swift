//
//  UILabel+Extensiton.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/17.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

extension UILabel  {
    convenience init(title:String,fontSize:CGFloat = 14,color:UIColor = UIColor.darkGray,screenInset:CGFloat = 0) {
        self.init()
        text = title
        textColor = color
        font = UIFont.systemFont(ofSize: fontSize)
        numberOfLines = 0
        
        if screenInset == 0 {
            textAlignment = .center
        }else {
            preferredMaxLayoutWidth = kScreenW - 2 * screenInset
            textAlignment = .left
        }
        sizeToFit()
    }
}
