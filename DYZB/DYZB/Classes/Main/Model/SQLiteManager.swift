//
//  SQLiteManager.swift
//  DYZB
//
//  Created by hairong chen on 2020/3/1.
//  Copyright © 2020 @huse.cn. All rights reserved.
//

import Foundation

class SQLiteManager {
    static let sharedManager = SQLiteManager()
    
    var db: OpaquePointer? = nil
    func openDB(dbName:String) {

        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent(dbName)
        
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("open the database failure")
            return
        }
        print("open the database success")
    }
}
