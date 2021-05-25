//
//  DataManager.swift
//  QiangGuoPlugs
//
//  Created by 张贺 on 2021/3/10.
//

import UIKit
import GRDB

struct DataBaseName {
    /// 数据库名字
    static let db = "QiangGuoDB.db"
}

/// 数据库表名
struct TableName {
    static let QuestionM = "questionM"
    static let ModelM = "modelM"
}

class DBManager: NSObject {
    
    private static var dbPath: String = {
        let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/\(DataBaseName.db)")
        return filePath
    }()
    
    private static var configuration: Configuration = {
        
        var configuration = Configuration()
        configuration.busyMode = Database.BusyMode.timeout(5.0)
        // 试图访问锁着的数据
        //configuration.busyMode = Database.BusyMode.immediateError
        return configuration
    }()
    
    // MARK: 创建数据 多线程
    static var dbQueue: DatabaseQueue = {
        let db = try! DatabaseQueue(path: DBManager.dbPath, configuration: DBManager.configuration)
        db.releaseMemory()
        return db
    }()
}
