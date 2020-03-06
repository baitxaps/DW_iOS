//
//  StatusDAL.swift
//  DYZB
//
//  Created by hairong chen on 2020/3/5.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation

// 数据访问层
class StatusDAL {
    class func loadStatus(since_id:Int,max_id:Int,finished:@escaping([[String:AnyObject]]?) ->()) {
        //1 本地有数据，返回本地缓存数据
        let array = checkCacheData(since_id:since_id,max_id:max_id)
        if array?.count ?? 0 > 0 {
            print("查询到数据 \(array!.count)")
            finished(array!)
            return
        }
        
        //2 没有数据加载网络数据
        var params = [String:Any]()
        if since_id > 0  {// 下拉
            params["since_id"] = "\(since_id))"
        }
        else if max_id > 0 {// 上拉
            params["max_id"] = "\(max_id))"
        }
        
        guard let token = UserAccountViewModel.shared.accesstoken else { 
            finished(nil)
            return
        }
        
        params["access_token"] = token
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        NetworkTools.requestData(.get, URLString: urlString, parameters:params) {(result, error) in
            if error != nil {
                print("出错了")
                finished(nil)
                return
            }
            
            print(result)
            guard let result = result as?[String:AnyObject] else {
                finished(nil)
                return
            }
            
            guard let array = result["statuses"] as? [[String:AnyObject]] else {
                print("format error")
                finished(nil)
                return
            }
            
            //3 网络数据存本地
            StatusDAL.saveCacheData(array: array)
            
            //4 返回网络数据
            finished(array)
        }
    }
    
    // 检查本地缓存
    /*
     SELECT statusId ,status, userId FROM T_Status
     WHERE userId = 1661108380
     -- AND statusId > 4479244547261295 下拉刷新
     AND statusId < 4479239376475591 -- 上拉刷新
     ORDER BY statusId DESC LIMIT 20
     */
    class func checkCacheData(since_id:Int,max_id:Int) -> [[String:AnyObject]]? {
        guard let userId = UserAccountViewModel.shared.account?.uid else {
            print("用户没有登录")
            return nil
        }
        
        var sql = "SELECT statusId ,status, userId FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        
        if since_id > 0 { //下拉刷新
            sql += "   AND statusId > \(since_id) \n"
        }else if max_id > 0 {//上拉刷新
            sql += "   AND statusId < \(max_id) \n"
        }
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        print("qeuey SQL ->" + sql)
        
        let array = FMDBManager.sharedManager.execRecordSet(sql: sql)
        //  print(array)
        
        var arrayM = [[String:AnyObject]]()
        for dict in array {
            let jsonData  = dict["status"] as! Data
            
            let result =  try! JSONSerialization.jsonObject(with: jsonData, options: [])
            //print(result)
            arrayM.append(result as! [String : AnyObject])
        }
        print(arrayM)
        return arrayM
    }
    
    
    /*
     sql 中必须包含主键,主键不能是自增长的,因为主键值需要指定
     主键不存在，新增记录，如果存在，修改记录
     
     INSERT OR REPLACE INTO T_Status (statusid, status,userId) VALUES (1,'T_Status',1001)
     */
    // DiskStorage
    class func saveCacheData(array:[[String:AnyObject]]) {
        guard let userId = UserAccountViewModel.shared.account?.uid else {
            print("用户没有登录")
            return
        }
        
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, status,userId) VALUES (?,?,?);"
        
        FMDBManager.sharedManager.queue.inTransaction { (db,rollback) -> Void in
            
            for dict in array {
                let statusId = dict["id"] as! Int
                let json = try! JSONSerialization.data(withJSONObject: dict, options: [])
                
                if !db.executeUpdate(sql,withArgumentsIn:[statusId,json,userId]) {
                    print("插入数据失败")
                    rollback.pointee = true
                    break
                }
            }
        }
        print("数据插入完成!")
    }
}
