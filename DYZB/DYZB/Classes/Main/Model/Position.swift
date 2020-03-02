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
    
    class func Positons() ->[Position]? {
        let sql = "SELECT id, name ,age ,height FROM T_Person;"
        
        SQLiteManager.sharedManager.execRecodSet(sql: sql)
        return nil
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
        let sql = "INSERT INTO T_Person (name,height) VALUES ('\(name!)',\(age));"
        id  = SQLiteManager.sharedManager.execInsert(sql: sql)
        return id > 0
    }
}


