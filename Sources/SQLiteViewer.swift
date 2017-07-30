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
