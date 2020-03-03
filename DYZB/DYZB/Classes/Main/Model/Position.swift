//
//  Position.swift
//  DYZB
//
//  Created by hairong chen on 2020/1/12.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import UIKit

@objcMembers
class Position: NSObject {
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
    
    func manyPositions() {
        //let start = CFAbsoluteTimeGetCurrent() // 会收到系统服务影响，在做性能测试时个，可能会有误差
        let start = CACurrentMediaTime()         // 只和硬件时间有关，做性能测试更准确
        
        print("start")
        // 开启事务
        SQLiteManager.sharedManager.execSQL(sql: "BEGIN TRANSACTION;")
        for i in 0..<10000 {
            //Position(dict: ["name":"kevin\(i)","age":18,"height":1.7]).insertPosition()
            // 断电,回滚事务 if i == 1000 {
            let p = Position(dict: ["name":"kevin\(i)","age":18,"height":1.7])
            if !p.insertPosition() {
                SQLiteManager.sharedManager.execSQL(sql: "ROLLBACK TRANSACTION;")
                break;
            }
        }
        // 提交事务
        SQLiteManager.sharedManager.execSQL(sql: "COMMIT TRANSACTION;")
        print("end:\(CACurrentMediaTime()-start))")
    }
    
    
    class func Positons() ->[Position]? {
        
        let sql = "SELECT id ,age ,height FROM T_Person;"
        
        guard let array = SQLiteManager.sharedManager.execRecodSet(sql: sql) else {
            return nil
        }
        
        var arrayM = [Position]()
        for dict in array {
            arrayM.append(Position(dict: dict))
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


