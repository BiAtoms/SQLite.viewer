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
        return true
    }
}

