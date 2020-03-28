//
//  FMDBManager.swift
//  DW_iOS
//
//  Created by hairong chen on 2020/3/3.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation

private let dbName = "status.db"

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
    
    // Query
    func execRecordSet(sql:String) ->[[String:Any]] {
        var result = [[String:Any]]()
        FMDBManager.sharedManager.queue.inDatabase { (db) in
            guard let rs = db.executeQuery(sql: sql) else {
                print("no result")
                return
            }
            
            while rs.next() {
                let colCount = rs.columnCount
                var dict = [String:Any]()
                
                for col in 0..<colCount {
                    let name = rs.columnName(for: col)
                    let obj = rs.object(forColumnIndex: col)
                    
                    //print("列数 \(name) \(obj)")
                    dict[name ?? ""] = obj
                }
                result.append(dict)
            }
          //  print(result)
        }
        return result
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
