//
//  UIImage+Extension.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/2/25.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

extension UIImage {
    func scalcToWith(width:CGFloat) -> UIImage {
        if width > size.width {
            return self
        }
        
        let height = size.height * width / size.width
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result ?? self
    }
}
