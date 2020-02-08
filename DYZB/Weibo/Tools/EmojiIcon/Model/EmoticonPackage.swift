//
//  EmoticonPackage.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/8.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

@objcMembers
class EmoticonPackage: NSObject {
    // 表情包的分组名
    var groupName: String?
    // 背景图片名称
    var bgImageName: String?
    // id
    var directory: String?
    // 懒加载的表情模型的空数组
    lazy var emoticons = [Emoticon]()
    
    init(array:[[String:AnyObject]]) {
        super.init()
        for d in array {
            emoticons.append(Emoticon(dict:d))
        }
    }
    /// 表情包目录，从目录下加载 info.plist 可以创建表情模型数组
//    var directory: String? {
//        didSet {
//            // 当设置目录时，从目录下加载 info.plist
//            guard let directory = directory,
//                let path = Bundle.main.path(forResource:"Emoticon.bundle", ofType: nil),
//                let bundle = Bundle(path: path),
//                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
//                let array = NSArray(contentsOfFile: infoPath) as? [[String: String]],
//
//                let models = toArrays(data: array)
//
//                else {
//                return
//            }
//
//            // 遍历 models 数组，设置每一个表情符号的目录
//            for m in models {
//                m.directory = directory
//            }
//
//            // 设置表情模型数组
//            emoticons += models
//        }
//    }
//
    override var description: String {
        let keys = ["groupName","bgImageName","emoticons"]
        return dictionaryWithValues(forKeys: keys).description
    }

}
