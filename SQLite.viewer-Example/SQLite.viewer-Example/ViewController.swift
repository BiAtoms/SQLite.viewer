//
//  ViewController.swift
//  SQLite.viewer-Example
//
//  Created by Orkhan Alikhanov on 7/2/17.
//  Copyright © 2017 BiAtoms. All rights reserved.
//

import UIKit
import SQLiteViewer
//todo copy sample databases into document folder.
class ViewController: UIViewController {
    let label: UILabel = {
        let label = UILabel(frame: UIScreen.main.bounds)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(label)
        updateUI()
    }
    
    func updateUI() {
        if let address = getWiFiAddress() {
            label.text = "Go to http://\(address):8081 in your browser."
        } else {
            label.text = "Connect to a wifi network and restart the app."
        }
    }
    
    
    //see https://stackoverflow.com/a/30754194/5555803
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
}
