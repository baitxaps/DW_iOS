//
//  StatusListViewModel.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/31.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation
import Kingfisher

class StatusListViewModel {
    lazy var statusList = [StatusViewModel]()
    
    // 移动端下拉刷新、上拉加载更多
    // pullup:是否上拉刷新标记
    func loadStatus(withPullup pullup:Bool ,since_id:Int,max_id:Int, finished:@escaping (_ isSuccessed:Bool)->()) {

        let tmp_since_id = pullup ? 0:since_id
        let tmp_max_id = pullup ? max_id - 1:0

        StatusDAL.loadStatus(since_id: tmp_since_id, max_id: tmp_max_id) { (array) in
            guard let array = array else {
                finished(false)
                return
            }

            var dataList = [StatusViewModel]()
            for dict in array {
                dataList.append(StatusViewModel(status: Status(dict:dict)))
            }
            print("get:\(dataList.count) datas")
            
            // join the data
            if tmp_max_id > 0 {
                 self.statusList += dataList
            }else {
               self.statusList = dataList + self.statusList
            }
            self.cacheSingleImage(dataList: dataList,finished:finished)
        }
    }
   
    private func cacheSingleImage(dataList:[StatusViewModel],finished:@escaping (_ isSuccessed:Bool)->()) {
        
        if dataList.count == 0 {
            finished(false)
            return
        }
        
        var dataLength = 0
        let group = DispatchGroup()
        
        for vm in dataList {
            let count = vm.thumbnailUrls?.count ?? 0
            if count  > 1 || count == 0 {
                finished(true)
                continue
            }
            
            let url = vm.thumbnailUrls![0]

            group.enter()
            KingfisherManager.shared.downloader.downloadImage(with: url, options:[KingfisherOptionsInfoItem.forceRefresh]) { (result) in
                //(Result<ImageLoadingResult, KingfisherError>
                switch result {
                case .failure(let error):
                    print(error)
                    group.leave()
                case .success(let response):
                    //response.image
                    let image:UIImage? = response.image
                    
                    guard image != nil else { return }
          
                    guard let data = (image!.pngData() as NSData?) else {
                        return
                    }
                    dataLength += data.length
     
                    group.leave()
                    print(response)
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
               print("cache dataLength:\(dataLength/1024) K")
                finished(true)
            }
        }
    }
}
