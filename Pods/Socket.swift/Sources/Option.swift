//
//  Option.swift
//  SocketSwift
//
//  Created by Orkhan Alikhanov on 7/7/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation //Darwin or Glibc

extension Socket {
    public struct Option: RawRepresentable {
        public let rawValue: Int32
        public init(rawValue: Int32) {
            self.rawValue = rawValue
        }
        public static let reuseAddress = Option(rawValue: SO_REUSEADDR)
    }
}
