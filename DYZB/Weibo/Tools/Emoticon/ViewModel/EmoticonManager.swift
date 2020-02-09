//
//  EmoticonViewModel.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/8.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation

// MARK: - emoticon.plist
/*
 1.emoticons.plist 定义表情包数组
 packages字典数组中，每一个id对应不同表情包的目录
 2.从每一个表情包目录中，加载info.plist可以获得不同的表情内容
 id 目录名
 group_name_cn 表情分组名称-显示在 toolbar上
 emoticons 数组
 字典
 chs 发送给服务器的字符串
 png 在本地显示的图片名称
 code emoji的字符串编码
 */
class EmoticonManager {
    static let sharedManager = EmoticonManager()
    
    lazy var packages = [EmoticonPackage]()
    private init() {
        loadPlist()
    }
    
    private func loadPlist() {
        packages.append(EmoticonPackage(array:[],dict:(["groupName":"最近"] as [String : AnyObject])))
        
        guard let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plist = bundle.path(forResource:"emoticons.plist", ofType: nil),
            let data = NSArray(contentsOfFile: plist) as? [[String: AnyObject]]
            else {
                return
        }
        
        for id:[String: AnyObject] in data  {
            //print(dictory)
            loadInfoPlist(dict: id)
        }
        print(packages)
    }
    
    private func loadInfoPlist(dict:[String: AnyObject]) {
        guard let dictory = dict["directory"] else {return}
        
        let path = Bundle.main.path(forResource:"info.plist", ofType: nil,inDirectory: "Emoticons.bundle/Contents/Resources/\(dictory)")!
        // print(path)
        let data = NSArray(contentsOfFile: path) as! [[String:AnyObject]]
        // print(data)
        
        packages.append(EmoticonPackage(array:data,dict:dict))
    }
}



















