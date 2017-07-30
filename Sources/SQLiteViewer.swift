//
//  SQLiteViewer.swift
//  SQLite.viewer
//
//  Created by Orkhan Alikhanov on 7/2/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import HttpSwift
import SQLite

open class SQLiteViewer {
    open static var shared = SQLiteViewer()
    
    public let assetDir: String = {
        let bundle = Bundle(for: SQLiteViewer.self)
        let url = bundle.resourceURL!
        return url.appendingPathComponent("com.biatoms.sqlite-viewer.assets.bundle").path
    }()
    
    public var dbDir: String = "" {
        didSet {
            db = DB(path: dbDir)
        }
    }
    
    lazy var server: Server = {
        let server = Server()
        self.prepareServer(server)
        return server
    }()
    
    var db: DB!
    
    func prepareServer(_ server: Server) {
        server.errorHandler = SQLiteErrorHanler.self
        
        let assetDir = self.assetDir
        let db = self.db!
        server.get("/") { _ in
            return try StaticServer.serveFile(in: assetDir, path: "index.html")
        }
        
        server.group("api") {
            server.group("databases") {
                server.group("/{name}") {
                    server.get("/tables/{table-name}") { r in
                        let dbName = r.routeParams["name"]!
                        let table = r.routeParams["table-name"]!
                        
                        return .success(try db.getTableData(db: dbName, table: table))
                    }
                    
                    server.get("/tables") { r in
                        let dbName = r.routeParams["name"]!
                        return .success(try db.getTableList(db: dbName))
                    }
                    
                    server.get("/download") { r in
                        let dbName = r.routeParams["name"]!
                        return try StaticServer.serveFile(at: "\(self.dbDir)/\(dbName)")
                    }
                    server.get("/execute") { r in
                        if let query = r.queryParams["query"] {
                            let dbName = r.routeParams["name"]!
                            return .success(try db.executeRawQuery(db: dbName, query: query))
                        }
                        
                        return .error("Query is missing. use `/execute?query=insert...`")
                    }
                }
            }
        }
        
        server.files(in: assetDir)
    }
    
    open func start(dbDir: String? = nil) {
        self.dbDir = dbDir ?? NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        server.run(port: 8081)
    }
    
    func stop() {
        server.stop()
    }
}

open class DB {
    open var path: String
    
    public init(path: String) {
        self.path = path
    }
    
    open func getCon(db: String) throws -> Connection{
        return try Connection("\(path)/\(db)")
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


extension Response {
    class func success(_ data: Any) -> Response {
        let json: [String: Any?] = [
            "success": true,
            "data": data
        ]
        return .json(json)
    }
    
    class func error(_ reason: String) -> Response {
        let json: [String: Any?] = [
            "success": false,
            "data": reason
        ]
        return .json(json)
    }
}


class SQLiteErrorHanler: ErrorHandler {
    override class func onError(request: Request?, error: Error) -> Response? {
        if let error = error as? SQLite.Result {
            return .error("\(error)")
        }
        return super.onError(request: request, error: error)
    }
}
