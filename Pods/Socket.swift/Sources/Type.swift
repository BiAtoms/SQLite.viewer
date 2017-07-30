//
//  Type.swift
//  SocketSwift
//
//  Created by Orkhan Alikhanov on 7/7/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation //Darwin or Glibc

#if os(Linux)
private let SOCK_STREAM = Int32(Glibc.SOCK_STREAM.rawValue)
private let SOCK_DGRAM = Int32(Glibc.SOCK_DGRAM.rawValue)
private let SOCK_RAW = Int32( Glibc.SOCK_RAW.rawValue)
private let SOCK_RDM = Int32(Glibc.SOCK_RDM.rawValue)
private let SOCK_SEQPACKET = Int32(Glibc.SOCK_SEQPACKET.rawValue)
#endif

extension Socket {
    public struct `Type`: OptionSet {
        public let rawValue: Int32
        public init(rawValue: Int32) { self.rawValue = rawValue }
        
        public static let stream = Type(rawValue: SOCK_STREAM)
        public static let datagram = Type(rawValue: SOCK_DGRAM)
        public static let raw = Type(rawValue: SOCK_RAW)
        public static let reliablyDeliveredMessage = Type(rawValue: SOCK_RDM)
        public static let sequencedPacketStream =  Type(rawValue: SOCK_SEQPACKET)
    }
}
