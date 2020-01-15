//
//  FunnyViewModel.swift
//  DYZB
//
//  Created by hairong chen on  10/14.
//  Copyright @huse.cn All rights reserved.
//

import UIKit

class FunnyViewModel : BaseViewModel {

}

//extension FunnyViewModel {
//    func loadFunnyData(finishedCallback : @escaping () -> ()) {
//        loadAnchorData(isGroupData: false, URLString: "http://capi.douyucdn.cn/api/v1/getColumnRoom/3", finishedCallback: finishedCallback)
//    }
//}


extension FunnyViewModel {
    func loadFunnyData(finishedCallback : @escaping () -> ()) {
        loadAnchorData(isGroupData: false, URLString: "http://capi.douyucdn.cn/api/v1/getColumnRoom/3", parameters: ["limit" : 30, "offset" : 0], finishedCallback: finishedCallback)
    }
}
