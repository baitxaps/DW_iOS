//
//  EmoticonViewModel.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/8.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

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
    
    // 最近表情,加入packages[0]中
    func addFavorite(em:Emoticon) {
        // 排序用
        em.times = em.times + 1
        
        if !packages[0].emoticons.contains(em) {
            packages[0].emoticons.insert(em, at: 0)
            
            // 删除倒数第二个按钮(emoticons保持21个，最后一个是删除按钮)
            packages[0].emoticons.remove(at: packages[0].emoticons.count - 2)
        }
        
        packages[0].emoticons.sort { $0.times > $1.times }
    }
    
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

// MARK: - 表情字符串的处理
extension EmoticonManager {
    /*
     根据 string `[爱你]` 在所有的表情符号中查找对应的表情模型对象
     */
    private func emotionWithString(string:String) ->Emoticon? {
        for package in packages {
            if let emoticon = package.emoticons.filter ({$0.chs == string}).last{
                return emoticon
            }
        }
        return nil
    }
    
 
    /*
     将给定的字符串转换成属性文本
     关键点：要按照匹配结果倒序替换属性文本
     */
    func emotionText(string:String,font: UIFont) ->NSAttributedString {
        let strM = NSMutableAttributedString(string: string)
    
        // [] () 都是正则表达式的关键字，如果要参与匹配，需要转义
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return strM
        }
        
        // 匹配所有项
        let matches = regx.matches(in: string, options: [],
                range: NSRange(location: 0, length: strM.length))
        
        // 倒序遍历
        var count = matches.count
        while count > 0 { //for m in matches.reversed()
            count = (count - 1)
            
            let range = matches[count].range(at: 0)
            let emStr = (strM.string as NSString).substring(with: range)
           
            if let em = emotionWithString(string: emStr) {
                let attrText = EmoticonAttachment(emoticon: em).imageText(font: font)
                print(attrText)
                
                strM.replaceCharacters(in: range, with: attrText)
            }
        }
        
        strM.addAttributes([NSAttributedString.Key.font: font,
                            NSAttributedString.Key.foregroundColor: UIColor.darkGray],
                           range: NSRange(location: 0, length: strM.length))
        return strM
    }
}


 /*
  在表情数组中过滤 string
  let emoticon = package.emoticons.filter ({(em) -> Bool in
      return em.chs == string
  }).last
  if emoticon != nil {
     return emoticon
  }

  尾随闭包
  if let emoticon = package.emoticons.filter ({(em) -> Bool in
      em.chs == string
  }).last{
      return emoticon
  }
  
 如果闭包中只有一句，并且是返回
   闭包格式定义可以省略,
  参数省略之后，使用 $0, $1... 依次替代原有的参数 $0对应就是数组中的元素
 */
















