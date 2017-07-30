//
//  OS.swift
//  Socket.swift
//
//  Created by Orkhan Alikhanov on 7/10/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import Foundation //Darwin or Glibc

struct OS {
    #if os(Linux)
    static let recv = Glibc.recv
    static let close = Glibc.close
    static let bind = Glibc.bind
    static let connect = Glibc.connect
    static let listen = Glibc.listen
    static let accept = Glibc.accept
    static let write = Glibc.write
    #else
    static let recv = Darwin.recv
    static let close = Darwin.close
    static let bind = Darwin.bind
    static let connect = Darwin.connect
    static let listen = Darwin.listen
    static let accept = Darwin.accept
    static let write = Darwin.write
    #endif
}
