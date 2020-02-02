//
//  StatusViewModel.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/1.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class StatusViewModel:CustomStringConvertible {
    var status:Status
    
    lazy var rowHeight:CGFloat = {
        let cell = StatusCell(style: .default, reuseIdentifier:StatusCellNormalId)
        
        return cell.rowHeight(vm: self)
    }()
    
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
    
    //!!! thumbnailUrls
    var thumbnailUrls:[URL]?
    
    init(status:Status) {
        self.status = status
        
        //
        if status.pic_urls?.count ?? 0 > 0 {
            thumbnailUrls = [URL]()
            
            for dict in status.pic_urls! {
                // dict按照key来取值，如果key错误，返回nil
                let url = URL(string: dict["thumbnail_pic"]!)
                // 相信服务器返回的url字符串一定能够生成
                thumbnailUrls?.append(url!)
            }
        }
    }
    
    // CustomStringConvertible (description)
    var description: String {
        return self.status.description + "配图数组\(thumbnailUrls ?? [])"
    }
}
