//
//  EmoticonAttachment.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/11.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {
    var emoticon:Emoticon
    
    func imageText(font:UIFont)->NSAttributedString {
        image = UIImage(contentsOfFile: emoticon.imagePath)
        // 线高表示字体的高度
        let height = font.lineHeight
        
        // frame = center + bounds * transform
        // bounds(x,y) = contentOffset
        bounds = CGRect(x: 0, y: -4, width: height, height: height)
        // 图片属性文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: self))
        
        // 设置字体属性
        imageText.addAttribute(NSAttributedString.Key.font,value:font, range: NSRange(location: 0, length: 1))
        
        return imageText
    }
    
    init(emoticon:Emoticon) {
        self.emoticon = emoticon
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
