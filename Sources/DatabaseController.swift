//
//  DatabaseController.swift
//  SQLiteViewer
//
//  Created by Orkhan Alikhanov on 7/30/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import SQLite

open class DatabaseController {
    open var path: String
    
    public init(path: String) {
        self.path = path
    }
    
    open func getCon(db: String) throws -> Connection {
        let path = "\(self.path)/\(db)"
        
        if !FileManager.default.fileExists(atPath: path) {
            throw SQLite.Result.error(message: "no such database: \(db)", code: 1, statement: nil)
        }
        
        return try Connection(path)
    }
    
    open func getList() throws -> [String] {
        let contents = try FileManager.default.contentsOfDirectory(atPath: path)
        let result = contents.filter { s in
            ["db", "sqlite", "sqlite2", "sqlite3"].reduce(false) {
                $0 || s.hasSuffix($1)
            }
        }
        return result
    }
    
    open func getTableList(db: String) throws -> [String] {
        var result = [String]()
        let db = try getCon(db: db)
        let nameColumn = Expression<String>("name")
        let type = Expression<String>("type")
        let query = Table("sqlite_master").select(nameColumn).where(type == "table")
        try db.prepare(query).forEach {
            result.append($0[nameColumn])
        }
        return result
    }
    
    open func getTableData(db: String, table: String) throws -> [String: Any] {
        let db = try getCon(db: db)
        return try selectQuery(db: db, query: "SELECT * FROM '\(table)'")
    }
    
    open func executeRawQuery(db: String, query: String) throws -> Any {
        let db = try getCon(db: db)
        
        if query.lowercased().contains("select") {
            return try selectQuery(db: db, query: query)
        }
        
        try db.run(query)
        return ["affected_rows": db.changes]
    }
    
    open func selectQuery(db: Connection, query: String) throws -> [String: Any] {
        let statement = try db.run(query)
        return [
            "columns": statement.columnNames,
            "rows": Array(statement)
        ]
    }
}
