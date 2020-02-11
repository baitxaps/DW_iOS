//
//  ProfileViewController.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/15.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit
// self->emoticonView ->clouse->self
class WBProfileTableViewController: VisitorTableViewController {
    
    private lazy var emoticonView:EmoticonView = EmoticonView {[weak self](emotion) in
//      self?.insertEmoticon(em: emotion)
        self?.textView.insertImageEmoticon(em: emotion)
    }
    
    fileprivate lazy var textView:UITextView = {
        let tv = UITextView()
        tv.frame = CGRect(x: 0, y: -200,width: kScreenW, height: 200)
        tv.font = UIFont.systemFont(ofSize: 20.0)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView?.setupInfo(imageName: nil,title:"关注一些人，回这里看看有什么惊喜")
        setupUI()
        print(EmoticonManager.sharedManager)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
}

extension WBProfileTableViewController {

    private func setupUI() {
        guard let tableView = tableView else {return}
        tableView.addSubview(textView)
        textView.inputView = emoticonView
        textView.text = "滑动隐藏键盘"
        
        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       var _ = self.textView.emotinText
    }
}

/*
 fileprivate func emotinText() {
     if textView.attributedText.length == 0 {return  }
     guard let attText = textView.attributedText else {return}
    
     var strM = String()
     
     attText.enumerateAttributes(in: NSRange(location: 0, length: attText.length), options: [], using: { (dict, range, _) in
         print("------")
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
     print("res :\(strM)")
 }
 
 
 fileprivate func insertImageEmoticon(em:Emoticon) {

     let attachment = EmoticonAttachment(emoticon: em)
     attachment.image = UIImage(contentsOfFile: em.imagePath)

     // 线高表示字体的高度
     let height = textView.font!.lineHeight

     // frame = center + bounds * transform
     // bounds(x,y) = contentOffset
     attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
     // 图片属性文本
     let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
     // 设置字体属性
     imageText.addAttribute(NSAttributedString.Key.font,value:textView.font!, range: NSRange(location: 0, length: 1))

     let attrStrM = NSMutableAttributedString(attributedString:textView.attributedText)

     attrStrM.replaceCharacters(in: textView.selectedRange, with: imageText)

     //
     let range = textView.selectedRange
     textView.attributedText = attrStrM
     textView.selectedRange = NSRange(location: range.location + 1, length: 0)
 }

 fileprivate func insertEmoticon(em:Emoticon) {
     if em.isEmpty {return}

     if em.isRemoved {
         textView.deleteBackward()
         return
     }

     if let emoji = em.emoji {
         textView.replace(textView.selectedTextRange!, withText: emoji)
         return
     }
 }
 */
