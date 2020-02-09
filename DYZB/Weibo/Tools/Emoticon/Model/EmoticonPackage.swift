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
    
    init(array:[[String:AnyObject]],dict:[String: AnyObject]) {
        super.init()
        
        groupName  = dict["groupName"] as? String ?? ""
        directory = dict["directory"] as? String ?? ""
        bgImageName = dict["bgImageName"] as? String ?? ""
        
        var index = 0
        for var d in array {
            if let png = d["png"] as? String,let dir = directory {
                d["png"] = dir + "/" + png as AnyObject
            }
            emoticons.append(Emoticon(dict:d))
            
            index += 1
            if index == 20 {
                emoticons.append(Emoticon(isRemoved:true))
                index = 0
            }
        }
        appendEmptyEmoticon()
    }
    
    private func appendEmptyEmoticon() {
        let count = emoticons.count % 21
        if emoticons.count > 0 && count == 0 {
            return
        }
        print("\(groupName ?? "") 剩余表情数量 \(count)")
        
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty:true))
        }
        emoticons.append(Emoticon(isRemoved:true))
    }
    
    // 表情包目录，从目录下加载 info.plist 可以创建表情模型数组
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
