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
    
    init(emoticon:Emoticon) {
        self.emoticon = emoticon
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
