//
//  UIImage+Extension.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/17.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

extension UIImageView {
    convenience init(imageName:String) {
        self.init(image: UIImage(named: imageName))
    }

}
