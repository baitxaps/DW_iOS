//
//  StatusViewModel.swift
//  DYZB
//
//  Created by hairong chen on 2020/2/1.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

class StatusViewModel {
    var status:Status
    
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
    
    init(status:Status) {
        self.status = status
    }
}
