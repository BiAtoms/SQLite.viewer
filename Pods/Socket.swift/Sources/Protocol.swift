//
//  Protocol.swift
//  Socket.swift
//
//  Created by Orkhan Alikhanov on 7/10/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//


import Foundation //Darwin or Glibc

extension Socket {
    public struct `Protocol`: RawRepresentable {
        public let rawValue: Int32
        public init(rawValue: Int32) { self.rawValue = rawValue }
        
        public static let tcp = Protocol(rawValue: Int32(IPPROTO_TCP))
        public static let udp = Protocol(rawValue: Int32(IPPROTO_UDP))
    }
}
