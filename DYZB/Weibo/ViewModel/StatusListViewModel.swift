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
    
    private var tokenDict:[String:String]? {
        if let token = UserAccountViewModel.shared.accesstoken {
            return ["access_token":token]
        }
        return nil
    }
    
    func loadStatus(finished:@escaping (_ isSuccessed:Bool)->()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        NetworkTools.requestData(.get, URLString: urlString, parameters:tokenDict) {(result, error) in
            if error != nil {
                print(error ?? "")
                finished(false)
                return
            }
            
            print(result)
            guard let result = result as?[String:AnyObject] else {
                finished(false)
                return
                
            }
            
            guard let array = result["statuses"] as? [[String:AnyObject]] else {
                print("format error")
                finished(false)
                return
            }
            var dataList = [StatusViewModel]()
            for dict in array {
                dataList.append(StatusViewModel(status: Status(dict:dict)))
            }
            print(dataList)
            // join the data
            self.statusList = self.statusList + dataList
           
            self.cacheSingleImage(dataList: dataList,finished:finished)
        }
    }
   
    private func cacheSingleImage(dataList:[StatusViewModel],finished:@escaping (_ isSuccessed:Bool)->()) {
        var dataLength = 0
        let group = DispatchGroup()
        
        for vm in dataList {
            let count = vm.thumbnailUrls?.count ?? 0
            if count  > 1 || count == 0 {
                continue
            }
            
            let url = vm.thumbnailUrls![0]

            group.enter()
            KingfisherManager.shared.downloader.downloadImage(with: url, options:[KingfisherOptionsInfoItem.forceRefresh,KingfisherOptionsInfoItem.onFailureImage(nil)]) { (result) in
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
