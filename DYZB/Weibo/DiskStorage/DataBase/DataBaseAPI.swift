//
//  Position.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/12.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

@objcMembers
class DataBaseAPI: NSObject {
    var id = 0
    var name:String? 
    var age :Int = 0
    var height :Double = 0
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description:String {
        let keys = ["name","age","height","id"]
        return dictionaryWithValues(forKeys: keys).description
        
        // return "\(dictionaryWithValues(forKeys: keys))"
    }
    
    override func setNilValueForKey(_ key: String) {
        if key == "age" {
            age = 0
        }else {
            super.setNilValueForKey(key)
        }
        
    }
    
    //MARK:- FMDB Test
    /*
     fmdb sql 注入
     fmdbInsert(name: "‘William',0,0);DELETE FROM T_Person; --")
     "INSERT INTO T_Person (name,height,age) VALUES (\'\'William\§',0,0);DELETE FROM T_Person; --\',18,19);"
     */
    func fmdbInsert(name:String) {
        let sql = "INSERT INTO T_Person (name,height,age) VALUES ('\(name)',18,19);"
        print(sql)
        
        FMDBManager.sharedManager.queue.inDatabase {(db)-> Void in
            // db.executeStatements(sql)
            // 更安全
            if(db.executeUpdate(sql:sql)) {
                print("executeUpdate .")
            }
        }
        manyFmdbPositions()
        //fmdbQueryColunm()
        // fmdbQuery()
        // fmdbDelete(id:8)
        // fmdbUpdate(dict: ["id":7,"name":"li","age":22,"height":1.6])
        // fmdbInsertDict(dict: ["name":"li","age":18,"height":1.9])
        // fmdbInsertArray(["zj",1.9,18])
    }
    
    // MARK:- Query
    
    //inTransaction 加入事务
    func manyFmdbPositions() {
        let sql = "INSERT INTO T_Person (name,height,age) VALUES (:name,:age,:height);"
        FMDBManager.sharedManager.queue.inTransaction { (db,rollback) -> Void in
            for i in 0..<20 {
                let name = "zhansan\(i)"
                let age = 20 + arc4random() % 20
                let dict :[String:Any] = ["name":name,"age":age,"height":height]
                
                if !db.executeUpdate(sql,withParameterDictionary:dict) {
                    rollback.pointee = true
                    break
                }
            }
        }
    }
 
    
    func fmdbQueryColunm() {
        let sql = "SELECT id,name,age,height FROM T_Person;"
        let array = FMDBManager.sharedManager.execRecordSet(sql: sql)
        print(array)
    }
    
    // 更依赖于对sql语句 的绑定
    func fmdbQuery() {
        let sql = "SELECT id,name,age,height FROM T_Person;"
        FMDBManager.sharedManager.queue.inDatabase { (db) in
            guard let rs = db.executeQuery(sql: sql) else {
                print("no result")
                return
            }
            while rs.next() {
                let id = rs.int(forColumn: "id")
                let name = rs.string(forColumn: "name")
                let age = rs.int(forColumn: "age")
                let height = rs.double(forColumn: "height")
                
                print("\(id) \(name) \(age) \(height)")
            }
        }
    }
    
    func fmdbDelete(id:Int) {
        let sql = "DELETE FROM T_Person WHERE id = :id;"
        print(sql)
        
        FMDBManager.sharedManager.queue.inDatabase {(db)-> Void in
            if(db.executeUpdate(sql, withArgumentsIn:[id])) {
                print("删除成功修改了 \(db.changes) 行")
            }else {
                print("失败")
            }
        }
    }
    
    
    
    func fmdbUpdate(dict:[String:Any]) {
        let sql = "UPDATE T_Person set name = :name, height = :height,age = :age \n" +
        "WHERE id = :id;"
        print(sql)
        
        FMDBManager.sharedManager.queue.inDatabase {(db)-> Void in
            if(db.executeUpdate(sql,withParameterDictionary:dict)) {
                print("成功更新了 \(db.changes) 行")
            }else {
                print("失败")
            }
        }
    }
    
    //
    func fmdbInsertDict(dict:[String:Any]) {
        // ？ 占位符,不需要用单引号
        // SQLite 首选编译 SQL，再执行的时候，动态绑定数据，同样可以避免注入
        let sql = "INSERT INTO T_Person (name,height,age) VALUES (:name,:age,:height);"
        print(sql)
        
        FMDBManager.sharedManager.queue.inDatabase {(db)-> Void in
            if(db.executeUpdate(sql,withParameterDictionary:dict)) {
                print("executeUpdate .")
            }
        }
    }
    
    
    func fmdbInsertArray(array:[Any]) {
        // ？ 占位符,不需要用单引号
        // SQLite 首选编译 SQL，再执行的时候，动态绑定数据，同样可以避免注入
        let sql = "INSERT INTO T_Person (name,height,age) VALUES (?,?,?);"
        print(sql)
        
        FMDBManager.sharedManager.queue.inDatabase {(db)-> Void in
            if(db.executeUpdate(sql,withArgumentsIn: array)) {
                print("executeUpdate .")
            }
        }
    }
    
    
    //MARK:- SQLite Test
    
    func manyPositions() {
        //let start = CFAbsoluteTimeGetCurrent() // 会收到系统服务影响，在做性能测试时个，可能会有误差
        let start = CACurrentMediaTime()         // 只和硬件时间有关，做性能测试更准确
        
        print("start")
        // 开启事务
        let _ = SQLiteManager.sharedManager.execSQL(sql: "BEGIN TRANSACTION;")
        for i in 0..<10000 {
            //DataBaseAPI(dict: ["name":"kevin\(i)","age":18,"height":1.7]).insertPosition()
            // 回滚事务
            let p = DataBaseAPI(dict: ["name":"kevin\(i)","age":18,"height":1.7])
            if !p.insertPosition() {
                let _ = SQLiteManager.sharedManager.execSQL(sql: "ROLLBACK TRANSACTION;")
                break;
            }
        }
        // 提交事务
        let _ = SQLiteManager.sharedManager.execSQL(sql: "COMMIT TRANSACTION;")
        print("end:\(CACurrentMediaTime()-start))")
    }
    
    
    class func Positons() ->[DataBaseAPI]? {
        
        let sql = "SELECT id ,age ,height FROM T_Person;"
        
        guard let array = SQLiteManager.sharedManager.execRecodSet(sql: sql) else {
            return nil
        }
        
        var arrayM = [DataBaseAPI]()
        for dict in array {
            arrayM.append(DataBaseAPI(dict: dict))
        }
        return arrayM
    }
    
    func deletePosiont() ->Bool {
        let sql = "DELETE FROM T_Person WHERE id = \(id);"
        let rows = SQLiteManager.sharedManager.execUpdate(sql: sql)
        return rows > 0
    }
    
    func updatePosition() -> Bool {
        let sql = "UPDATE T_Person SET name ='\(name!)',age =\(age) ,height = \(height) \n" +
        "WHERE id =\(id);"
        
        let rows = SQLiteManager.sharedManager.execUpdate(sql: sql)
        return rows > 0
    }
    
    func insertPosition() ->Bool {
        let sql = "INSERT INTO T_Person (name,height,age) VALUES ('\(name!)',\(height),\(age));"
        id  = SQLiteManager.sharedManager.execInsert(sql: sql)
        return id > 0
    }
}


