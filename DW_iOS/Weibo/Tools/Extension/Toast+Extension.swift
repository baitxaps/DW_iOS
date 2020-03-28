//
//  Toast+Extension.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/2/29.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIView {
    func Toast(text:String,duration:Double = 3.0,positon:ToastPosition = .center) {
        makeToast(text, duration:duration, position: positon)
    }
}

