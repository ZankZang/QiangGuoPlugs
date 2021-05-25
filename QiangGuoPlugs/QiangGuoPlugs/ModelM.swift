//
//  ModelM.swift
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/3/11.
//

import UIKit
import GRDB

class ModelM: Codable {
    var name: String = ""
    var x: String = ""
    var y: String = ""
    var wid: String = ""
    var hei: String = ""
    var img: String = ""
    var tid: String = ""
    
    private enum Columns: String, CodingKey, ColumnExpression {
        case name
        case x
        case y
        case wid
        case hei
        case img
        case tid
    }
}


extension ModelM: MutablePersistableRecord, FetchableRecord {
    
    private static let dbQueue: DatabaseQueue = DBManager.dbQueue
    
    private static func createTable() -> Void {
        try! self.dbQueue.inDatabase { (db) -> Void in
            if try db.tableExists(TableName.ModelM) {
                return
            }
            try db.create(table: TableName.ModelM, temporary: false, ifNotExists: true, body: { (t) in
                t.column(Columns.name.rawValue, Database.ColumnType.text)
                t.column(Columns.x.rawValue, Database.ColumnType.text)
                t.column(Columns.y.rawValue, Database.ColumnType.text)
                t.column(Columns.wid.rawValue, Database.ColumnType.text)
                t.column(Columns.hei.rawValue, Database.ColumnType.text)
                t.column(Columns.img.rawValue, Database.ColumnType.text)
                t.column(Columns.tid.rawValue, Database.ColumnType.text)
            })
        }
    }
    
    static func insert(modelM: ModelM) -> Void {
        self.createTable()
        try! self.dbQueue.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                var tempM = modelM
                try tempM.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        }
    }
    
    static func queryAll() -> [ModelM] {
        self.createTable()
        return try! self.dbQueue.unsafeRead({ (db) -> [ModelM] in
            return try ModelM.fetchAll(db)
        })
    }
    
    static func update(modelM: ModelM) -> Void {
        self.createTable()
        try! self.dbQueue.inDatabase { (db) in
            try db.execute(sql: String(format: "UPDATE modelM SET x = '%@',y = '%@',wid = '%@',hei = '%@' WHERE name = '%@'", modelM.x, modelM.y, modelM.wid, modelM.hei, modelM.name))
        }
    }
}
