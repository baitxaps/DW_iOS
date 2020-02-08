//
//  Emoticon.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/8.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

@objcMembers
class Emoticon: NSObject {
    // 表情类型 false - 图片表情 / true - emoji
    var type = false
    // 表情字符串，发送给新浪微博的服务器(节约流量)
    var chs: String?
    // 表情图片名称，用于本地图文混排
    var png: String?
    // 表情使用次数
    var times: Int = 0
    // emoji 的字符串
    var emoji: String?
    // 表情模型所在的目录
    var directory: String?
    
    var code: String? {
        didSet {
            guard let code = code else {
                return
            }
            emoji = code.emoji
        }
    }
    /// `图片`表情对应的图像
    var image: UIImage? {
        // 判断表情类型
        if type {
            return nil
        }

        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil),
            let bundle = Bundle(path: path)
            else {
                return nil
        }

        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {}

    override var description: String {
        let keys = ["chs","png","code","type","times","emoji","directory"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
