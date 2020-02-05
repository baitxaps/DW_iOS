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
    
    private var params = [String:String]()
    
    private var tokenDict:[String:String]? {
        if let token = UserAccountViewModel.shared.accesstoken {
            return ["access_token":token]
        }
        return nil
    }
    
    func loadStatus(withIsPull isPull:Bool ,since_id:Int,max_id:Int, finished:@escaping (_ isSuccessed:Bool)->()) {
        
        let tmp_since_id = isPull ? 0:since_id
        let tmp_max_id = isPull ? max_id - 1:0
        
        // 下拉
        if tmp_since_id > 0  {
            params["since_id"] = "\(tmp_since_id))"
        }
        // 上拉
        else if tmp_max_id > 0 {
            params["max_id"] = "\(tmp_max_id))"
        }
        
        for(key,value) in (tokenDict ?? [:]) {params[key] = value}
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        NetworkTools.requestData(.get, URLString: urlString, parameters:params) {(result, error) in
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
