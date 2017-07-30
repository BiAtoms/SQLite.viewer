//
//  SQLiteViewerTests.swift
//  SQLiteViewerTests
//
//  Created by Orkhan Alikhanov on 7/30/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import XCTest
import SQLite
import HttpSwift
import Alamofire
@testable import SQLiteViewer


class SQLiteViewerTests: XCTestCase {
    
    struct statics {
        static let client = SessionManager.default
    }
    
    
    var client: SessionManager {
        return statics.client
    }
    
    override class func setUp() {
        super.setUp()
        SQLiteViewer.shared.start(assetDir: Bundle(for: SQLiteViewer.self).resourcePath!)
        setUpDb()
    }
    
    class func setUpDb() {
        let manager = FileManager.default
        let path = "\(SQLiteViewer.shared.dbDir)/db.sqlite"
        if manager.fileExists(atPath: path) {
            try! manager.removeItem(atPath: path)
        }
        
        let db = try! Connection(path)
        
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        
        try! db.run(users.create { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(email, unique: true)
        })
        
        [
            users.insert(name <- "Alice", email <- "alice@mac.com"),
            users.insert(name <- "John", email <- "john@apple.com")
        ].forEach{
            try! db.run($0)
        }
    }
    
    func testDbList() {
        let ex = expectation(description: "testDbList")
        client.request("/databases").responseJSON { r in
            let json = r.value as! [String: Any]
            XCTAssertEqual(json["success"] as? Bool, true)
            XCTAssertEqual(json["data"] as! [String], ["db.sqlite"])
            ex.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testTableList() {
        let ex = expectation(description: "testTableList")
        client.request("/databases/db.sqlite/tables").responseJSON { r in
            let json = r.value as! [String: Any]
            XCTAssertEqual(json["success"] as? Bool, true)
            XCTAssertEqual(json["data"] as! [String], ["users"])
            ex.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testTableData() {
        let ex = expectation(description: "testTableData")
        client.request("/databases/db.sqlite/tables/users").responseJSON { r in
            let json = r.value as! [String: Any]
            XCTAssertEqual(json["success"] as? Bool, true)
            let (cols, rows) = self.extractTable(json["data"])
            XCTAssertEqual(cols, ["id", "name", "email"])
            XCTAssertEqual(NSArray(array: rows), NSArray(array: [
                [1, "Alice", "alice@mac.com"],
                [2, "John", "john@apple.com"]
            ]))
            
            ex.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testRawExecute() {
        let query1 = "INSERT INTO 'users' values(3, 'test1', 'test1@t.com'), (4, 'test2', 'test2@t.com')"
        
        let ex1 = expectation(description: "testRawExecute1")
        client.request("/databases/db.sqlite/execute", parameters: ["query": query1]).responseJSON { r in
            let json = r.value as! [String: Any]
            XCTAssertEqual(json["success"] as? Bool, true)
            let affectedRows = (json["data"] as! [String:Int])["affected_rows"]!
            XCTAssertEqual(affectedRows, 2)
            ex1.fulfill()
        }
        wait(for: [ex1], timeout: 1)
        
        
        let query2 = "SELECT id, email FROM 'users' where id > 2"
        
        let ex2 = expectation(description: "testRawExecute2")
        client.request("/databases/db.sqlite/execute", parameters: ["query": query2]).responseJSON { r in
            let json = r.value as! [String: Any]
            XCTAssertEqual(json["success"] as? Bool, true)
            let (cols, rows) = self.extractTable(json["data"])
            XCTAssertEqual(cols, ["id", "email"])
            XCTAssertEqual(NSArray(array: rows), NSArray(array: [
                [3, "test1@t.com"],
                [4, "test2@t.com"]
                ]))
            
            ex2.fulfill()
        }
        wait(for: [ex2], timeout: 1)
        
        
        let query3 = "DELETE FROM users WHERE id > 2"
        
        let ex3 = expectation(description: "testRawExecute3")
        client.request("/databases/db.sqlite/execute", parameters: ["query": query3]).responseJSON { r in
            let json = r.value as! [String: Any]
            XCTAssertEqual(json["success"] as? Bool, true)
            let affectedRows = (json["data"] as! [String:Int])["affected_rows"]!
            XCTAssertEqual(affectedRows, 2)
            ex3.fulfill()
        }
        wait(for: [ex3], timeout: 1)
    }
    
    
    func testError() {
        let query = "INSERT INTO users values(1, 'non-unique', 'alice@mac.com')"
        
        let ex = expectation(description: "testError")
        client.request("/databases/db.sqlite/execute", parameters: ["query": query]).responseJSON { r in
            let json = r.value as! [String: Any]
            XCTAssertEqual(json["success"] as? Bool, false)
            XCTAssertEqual(json["data"] as! String, "UNIQUE constraint failed: users.id (code: 19)")
            ex.fulfill()
        }

        let ex2 = expectation(description: "testError2")
        client.request("/databases/db.sqlite/tables/my_table").responseJSON { r in
            let json = r.value as! [String: Any]
            XCTAssertEqual(json["success"] as? Bool, false)
            XCTAssertEqual(json["data"] as! String, "no such table: my_table (code: 1)")
            ex2.fulfill()
        }
        
        let ex3 = expectation(description: "testError3")
        client.request("/databases/my_database/tables").responseJSON { r in
            let json = r.value as! [String: Any]
            XCTAssertEqual(json["success"] as? Bool, false)
            XCTAssertEqual(json["data"] as! String, "no such database: my_database (code: 1)")
            ex3.fulfill()
        }
        
        
        
        waitForExpectations(timeout: 1)
    }
    
    func testDownload() {
        let ex = expectation(description: "testDownload")
        client.request("/databases/db.sqlite/download").responseData { r in

            //see https://www.sqlite.org/fileformat.html#magic_header_string
            //we have "SQLite format 3" including the nul terminator character at the end.
            XCTAssertEqual(String(cString: Array(r.value!)), "SQLite format 3")
            ex.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testIndexHtml() {
        let ex = expectation(description: "testIndexHtml")
        client.request("http://localhost:8081/" as URLConvertible).responseString { r in
            XCTAssert(r.value!.hasPrefix("<!DOCTYPE html>"))
            ex.fulfill()
        }
        waitForExpectations(timeout: 1000)
    }
    
    func extractTable(_ data: Any?) -> (columns: [String], rows: [[Any]]) {
        let data = data as! [String: Any]
        let columns = data["columns"] as! [String]
        let rows = data["rows"] as! [[Any]]
        
        return (columns, rows)
    }
}


extension SessionManager {
    @discardableResult
    func request(_ url: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> DataRequest {
        let base = "http://localhost:8081/api"
        let url: URLConvertible = (base as NSString).appendingPathComponent(url)
        
        return self.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}
