//
//  QuestionM.swift
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/3/10.
//

import UIKit
import GRDB

class QuestionM: Codable {
    
    var checkQuestion: String = ""
    var originalQuestion: String = ""
    var firstImgStr: String = ""
    var secondImgStr: String = ""
    var thirdImgStr: String = ""
    var itemId: String = ""
    var answer: String = ""
    
    private enum Columns: String, CodingKey, ColumnExpression {
        case originalQuestion
        case checkQuestion
        case answer
        case firstImgStr
        case secondImgStr
        case thirdImgStr
        case itemId
    }
}


extension QuestionM: MutablePersistableRecord, FetchableRecord {
    
    private static let dbQueue: DatabaseQueue = DBManager.dbQueue
    
    private static func createTable() -> Void {
        try! self.dbQueue.inDatabase { (db) -> Void in
            if try db.tableExists(TableName.QuestionM) {
                return
            }
            try db.create(table: TableName.QuestionM, temporary: false, ifNotExists: true, body: { (t) in
                t.column(Columns.originalQuestion.rawValue, Database.ColumnType.text)
                t.column(Columns.checkQuestion.rawValue, Database.ColumnType.text)
                t.column(Columns.answer.rawValue, Database.ColumnType.text)
                t.column(Columns.firstImgStr.rawValue, Database.ColumnType.text)
                t.column(Columns.secondImgStr.rawValue, Database.ColumnType.text)
                t.column(Columns.thirdImgStr.rawValue, Database.ColumnType.text)
                t.column(Columns.itemId.rawValue, Database.ColumnType.text)
            })
        }
    }
    
    static func insert(questionM: QuestionM) -> Void {
        try! self.dbQueue.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                var tempM = questionM
                try tempM.insert(db)
                return Database.TransactionCompletion.commit
            } catch {
                return Database.TransactionCompletion.rollback
            }
        }
    }
    
    static func query(question: String) -> [QuestionM] {
        return try! self.dbQueue.unsafeRead({ (db) -> [QuestionM] in
            return try QuestionM.fetchAll(db, sql: String.init(format: "SELECT * FROM questionM WHERE checkQuestion LIKE '%%%@%%'", question))
        })
    }
    
    static func query(imgStr: String, name: String) -> [QuestionM] {
        return try! self.dbQueue.unsafeRead({ (db) -> [QuestionM] in
            return try QuestionM.fetchAll(db, sql: String.init(format: "SELECT * FROM questionM WHERE %@ LIKE '%%%@%%'", name == "挑战答题" ? "cImgStr" : "bImgStr", imgStr))
        })
    }
    
    static func queryAll() -> [QuestionM] {
        self.createTable()
        return try! self.dbQueue.unsafeRead({ (db) -> [QuestionM] in
            return try QuestionM.fetchAll(db)
        })
    }
    
    static func update(questionM: QuestionM) -> Void {
        try! self.dbQueue.inDatabase { (db) in
            try db.execute(sql: String(format: "UPDATE questionM SET originalQuestion = '%@',checkQuestion = '%@',answer = '%@',firstImgStr = '%@',secondImgStr = '%@',thirdImgStr = '%@' WHERE ind = '%d'", questionM.originalQuestion, questionM.checkQuestion, questionM.answer, questionM.firstImgStr, questionM.secondImgStr, questionM.thirdImgStr, questionM.itemId))
        }
    }
}
