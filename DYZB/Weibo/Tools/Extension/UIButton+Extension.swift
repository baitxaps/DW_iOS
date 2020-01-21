//
//  UIButton+Extension.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(imageName:String,backImageName:String) {
        self.init()
        
        setImage(UIImage(named:imageName),for: UIControl.State.normal)
        setImage(UIImage(named:imageName+"_highlighted"),for:.highlighted)
        
        setBackgroundImage(UIImage(named:backImageName),for:UIControl.State.normal)
        
        setBackgroundImage(UIImage(named:backImageName+"_highlighted"),for:.highlighted)
        sizeToFit()
    }
    
    
    convenience init(title:String,color:UIColor,imageName:String) {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setBackgroundImage(UIImage(named: imageName), for: .normal)
        
        sizeToFit()
    }
}
