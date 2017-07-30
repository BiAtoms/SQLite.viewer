//
//  ApiRespose.swift
//  SQLiteViewer
//
//  Created by Orkhan Alikhanov on 7/30/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import HttpSwift

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
