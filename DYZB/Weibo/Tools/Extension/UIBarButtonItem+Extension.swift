//
//  UIBarButtonItem+Extension.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/23.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience  init(image:String,target:AnyObject?,actionName:String?) {
        let btn = UIButton(imageName: image, backImageName: nil)
        if let actionName = actionName {
             btn.addTarget(target, action: Selector(actionName), for:.touchUpInside)
        }
        self.init(customView:btn)
    }
    
    /*
    class func createItem(imageName : String, highImageName : String, size : CGSize) -> UIBarButtonItem {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
        
        btn.frame = CGRect(origin: CGPointZero, size: size)
        
        return UIBarButtonItem(customView: btn)
    }
    */
    
    // 便利构造函数: 1> convenience开头 2> 在构造函数中必须明确调用一个设计的构造函数(self)
    convenience init(imageName : String, highImageName : String = "", size : CGSize = CGSize.zero)  {
        // 1.创建UIButton
        let btn = UIButton()
        
        // 2.设置btn的图片
        btn.setImage(UIImage(named: imageName), for: UIControl.State())
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        
        // 3.设置btn的尺寸
        if size == CGSize.zero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        // 4.创建UIBarButtonItem
        self.init(customView : btn)
    }
}



