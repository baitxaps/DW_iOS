//
//  StatusViewModel.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/2/1.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class StatusViewModel:CustomStringConvertible {
    var status:Status
    
    var cellId:String {
        return status.retweeted_status != nil ? StatusCellRetweetedId:StatusCellNormalId
    }
    
    lazy var rowHeight:CGFloat = {
        var cell:StatusCell
        
        if self.status.retweeted_status != nil {
            cell = StatusRetweetedCell(style:.default,reuseIdentifier:StatusCellRetweetedId)
        }else {
            cell = StatusNormalCell(style:.default,reuseIdentifier:StatusCellNormalId)
        }
        
        return cell.rowHeight(vm: self)
    }()
    
    // 计算型属性
    var createAt:String? {
        return Date.sinaDate(string: status.created_at ?? "")?.dateDescription
    }
    
    var userProfileUrl:URL {
        return URL(string: status.user?.profile_image_url ?? "")!
    }
    
    var userDefaultIconView:UIImage? {
        return UIImage(named:"avatar_default_big")!
    }
    
    var userMemberImage:UIImage? {
        guard let mbrank = status.user?.mbrank else {
            return nil
        }
        
        if mbrank < 0 || mbrank > 7 {
            return nil
        }
        
        return UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
    }
    
    //认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var userVipImage:UIImage? {
        switch (status.user?.verified_type ?? -1) {
        case 0:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
    }
    
    // 存储型属性!!!
    // 如果是原创微博，可以有图，可以没有图
    // 如果是转发微博，一定没有图，retweeted_status中，可以有图，可以没有图
    // 一条微博，最多只有一个pic_urls数组
    var thumbnailUrls:[URL]?
    
    var retweetedText:String? {
        guard let s = status.retweeted_status else {
            return nil
        }
        
        let retweet = "@" + (s.user?.screen_name ?? "")
        
        return (retweet + ":" + (s.text ?? ""))
    }
    
    init(status:Status) {
        self.status = status
        
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls {
            thumbnailUrls = [URL]()
            for dict in urls {
                // dict按照key来取值，如果key错误，返回nil
                if let url = URL(string: (dict["thumbnail_pic"]!)) {
                    thumbnailUrls?.append(url)
                }
            }
        }
    }
    
    // CustomStringConvertible (description)
    var description: String {
        return self.status.description + "配图数组\(thumbnailUrls ?? [])"
    }
}
