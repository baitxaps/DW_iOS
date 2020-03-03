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
    
    private var db: OpaquePointer? = nil
    func openDB(dbName:String) {

        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent(dbName)
        
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("open the database failure")
            return
        }
    
        if createTable2() {
           print("create the Table success")
        }else {
            print("create the Table failure")
        }
    }
    
    // 数据查询操作
    // 执行SQL 返回数据结果集合
    func execRecodSet(sql:String)->[[String:AnyObject]]? {
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("SQL Error")
            sqlite3_finalize(stmt)
            return nil
        }
        print("SQL correct")
        
        var result = [[String:AnyObject]]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            result.append(record(stmt: stmt!))
            
        }
        print(result)
        sqlite3_finalize(stmt)
        
        return result
    }
    
    private func record(stmt:OpaquePointer) ->[String:AnyObject] {
        // 记录的列数
        let cols = sqlite3_column_count(stmt)
        
        var row = [String:AnyObject]()
        
        for col in 0..<cols {
            // 列名 Int 8 /CChar /Byte
            let cName = sqlite3_column_name(stmt, col)!

            let name = String(cString: cName, encoding: String.Encoding.utf8)
           // let name = String(cString: cName)
            // data type
            let type = sqlite3_column_type(stmt, col)
            var value :AnyObject?
            switch type {
            case SQLITE_FLOAT:
                value = sqlite3_column_double(stmt, col) as AnyObject
            case SQLITE_INTEGER:
                value = sqlite3_column_int64(stmt, col) as AnyObject
                
            case SQLITE_TEXT:
                value = sqlite3_column_text(stmt, col) as AnyObject
//                let cText = UnsafePointer<UInt8>(sqlite3_column_text(stmt, col))
//                value =  String(cString:cText, encoding:String.Encoding.utf8)
            case SQLITE_NULL:
                value = NSNull()
            default:
                print("error type")
            }
          //  print ("--\(name) --\(type)-- \(value)--")
            
            row[name!] = value
        }
        print(row)
        return row
    }
    
    // 执行 SQL 更新 /删除 数据
    func execUpdate(sql:String) ->Int {
        if !execSQL(sql: sql) {
            return -1
        }
        // 执行成功，返回影响的数据行数
        return Int(sqlite3_changes(db))
    }
    

    func execInsert(sql:String) ->Int {
        if !execSQL(sql: sql) {
            return -1
        }
        // 返回自动增长的 id ，最后一条插入数据的id
       return Int(sqlite3_last_insert_rowid(db))
    }
    
    func execSQL(sql:String) -> Bool {
      return  sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
    }
    
    // 商业上一般用这个
    private func createTable2() -> Bool {
        let path = Bundle.main.path(forResource: "db.sql", ofType: nil)!
        let sql = try! String(contentsOfFile: path)
        return execSQL(sql: sql)
    }
    
    // 在开发数据库时，大多数据问题，是SQL问题，借助天navicat 辅助做语法检查
    // 加\n 避免字符串拼接错误
    private func createTable()-> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS 'T_Person' (\n" +
            "'id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\n" +
            "'name' TEXT,\n" +
            "'age' INTEGER,\n" +
            "'height' REAL\n" +
        ");"
        print(sql)
        return execSQL(sql: sql)
    };
}
