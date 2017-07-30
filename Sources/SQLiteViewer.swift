//
//  SQLiteViewer.swift
//  SQLite.viewer
//
//  Created by Orkhan Alikhanov on 7/2/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import HttpSwift

open class SQLiteViewer {
    open static var shared = SQLiteViewer()
    
    public let assetDir: String = {
        let bundle = Bundle(for: SQLiteViewer.self)
        let url = bundle.resourceURL!
        return url.appendingPathComponent("com.biatoms.sqlite-viewer.assets.bundle").path
    }()
    
    private lazy var server: Server = {
        let server = Server()
    
        var dirr = self.assetDir
        server.get("/") { _ in
            return try StaticServer.serveFile(in: dirr, path: "index.html")
        }
        
        server.group("api") {
            server.group("databases") {
                server.get("") { _ in
                    return .json(["d":"d"])
                }
//                server.get("/{name}")
//                server.get("/{name}/tables")
//                server.get("/{name}/tables/{table-name}")
            }
        }
        
        server.files(in: dirr)
        return server
    }()
    
    open func start(dbDir: String? = nil) {
       server.run(port: 8081)
    }
    
    func stop() {
        server.stop()
    }
}
