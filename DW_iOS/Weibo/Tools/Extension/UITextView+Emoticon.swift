//
//  UITextView+Emoticon.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/2/11.
//  Copyright © 2020 @huse.cn. All rights reserved.
//


import UIKit

extension UITextView {
    // 图片表情,字符串内容
    // func emotinText() ->String {
    var emotinText:String {
        if attributedText.length == 0 {return "" }
        guard let attText = attributedText else {return ""}
       
        var strM = String()
        
        attText.enumerateAttributes(in: NSRange(location: 0, length: attText.length), options: [], using: { (dict, range, _) in
           // print("------")
            let key : NSAttributedString.Key = NSAttributedString.Key(rawValue: "NSAttachment")
            if let attachemnt = dict[key] as? EmoticonAttachment {
              //  print("pic:\(attachemnt.emoticon)")
                strM += attachemnt.emoticon.chs ?? ""
            }else {
                let str = (attText.string as NSString).substring(with: range)
              //  print(str)
                strM += str
            }
        })
       // print("res :\(strM)")
        return strM
    }
    
    
    func insertImageEmoticon(em:Emoticon) {
        // image var
        let imageText = EmoticonAttachment(emoticon: em).imageText(font: font!)
        // UITextView.attributedText -> NSMutableAttributedString
        let attrStrM = NSMutableAttributedString(attributedString:attributedText)
        // insert imageText
        attrStrM.replaceCharacters(in: selectedRange, with: imageText)
        
        let range = selectedRange
        attributedText = attrStrM
        //res pin
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
    
    func insertEmoticon(em:Emoticon) {
        if em.isEmpty {return}
        
        if em.isRemoved {
            deleteBackward()
            return
        }
        
        if let emoji = em.emoji {
            replace(selectedTextRange!, withText: emoji)
            return
        }
        
        insertImageEmoticon(em: em)
        
        delegate?.textViewDidChange?(self)
    }
}
