//
//  FMDBManager.swift
//  DYZB
//
//  Created by hairong chen on 2020/3/3.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation

private let dbName = "demo.db"

class FMDBManager {
    
    static let sharedManager = FMDBManager()
    let queue:FMDatabaseQueue
    
    private init() {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent(dbName)
        
        print("db path " + path)
        queue = FMDatabaseQueue(path: path)!
        
        createTable()
    }
    
    private func createTable() {
        let path = Bundle.main.path(forResource: "db.sql", ofType: nil)!
        let sql = try! String(contentsOfFile: path)
        
        queue.inDatabase { (db) in
            // db.executeUpdate(sql: sql)
            
            // 可以执行多个SQL,保证一致性创建所有的数据表
            if db.executeStatements(sql)  {
                print("create the Table success")
            }else {
                print("create the Table failure")
            }
        }
    }
}
