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
}



