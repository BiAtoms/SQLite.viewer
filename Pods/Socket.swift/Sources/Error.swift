//
//  SocketError.swift
//  Socket.swift
//
//  Created by Orkhan Alikhanov on 7/6/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation

@discardableResult
public func ing(block: (() -> Int32)) throws -> Int32 {
    let value = block()
    if value == -1 {
        throw Socket.Error(errno: errno)
    }
    return value
}

extension Socket {
    struct Error: Swift.Error, Equatable, CustomStringConvertible {
        let errno: Int32
        
        init(errno: Int32) {
            self.errno = errno
        }
        
        public static func == (lhs: Error, rhs: Error) -> Bool {
            return lhs.errno == rhs.errno
        }
        
        public var description: String {
            return "SocketError: " + String(cString: UnsafePointer(strerror(self.errno)))
        }
    }
}

extension Socket.Error {
    public static let aa = Socket.Error(errno: 13)
}
