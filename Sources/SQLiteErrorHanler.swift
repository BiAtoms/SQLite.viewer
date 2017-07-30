//
//  SQLiteErrorHanler.swift
//  SQLiteViewer
//
//  Created by Orkhan Alikhanov on 7/30/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import HttpSwift
import SQLite

class SQLiteErrorHanler: ErrorHandler {
    override class func onError(request: Request?, error: Error) -> Response? {
        if let error = error as? SQLite.Result {
            return .error("\(error)")
        }
        return super.onError(request: request, error: error)
    }
}
