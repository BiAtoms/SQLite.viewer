//
//  Family.swift
//  SocketSwift
//
//  Created by Orkhan Alikhanov on 7/7/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation //silently Glibc

extension Socket {
    public struct Family: RawRepresentable {
        public let rawValue: Int32
        public init(rawValue: Int32) { self.rawValue = rawValue }
        
        public static let inet = Family(rawValue: AF_INET)
        public static let inet6 = Family(rawValue: AF_INET6)
        public static let unix = Family(rawValue: AF_UNIX)
    }
}
