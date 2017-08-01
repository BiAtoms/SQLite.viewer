//
//  AppDelegate.swift
//  SQLite.viewer-Example
//
//  Created by Orkhan Alikhanov on 7/2/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import SQLiteViewer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SQLiteViewer.shared.start()
        SQLiteViewer.shared.db.extensions.append("sl3") //for matching Northwind.sl3
        
        copyDbsToDocumentsFolderIfNeeded()
        return true
    }
    
    
    func copyDbsToDocumentsFolderIfNeeded() {
        let manager = FileManager.default
        let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let bundlePath = Bundle.main.resourcePath!
        let dbs = try! manager.contentsOfDirectory(atPath: bundlePath).filter { s in SQLiteViewer.shared.db.extensions.reduce(false) { $0 || s.hasSuffix($1) } }
        
        dbs.forEach {
            let path = "\(docsPath)/\($0)"
            if !manager.fileExists(atPath: path) {
                try! manager.copyItem(atPath: "\(bundlePath)/\($0)", toPath: path)
            }
        }
        
    }
}

