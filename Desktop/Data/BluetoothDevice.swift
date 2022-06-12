//
//  BluetoothDevice.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation

struct BluetoothDevice {
    var id = UUID()
    
    enum Status: String {
        case connected = "Connected"
        case disconnected = "Disconnected"
        case unknown = "Unknown"
        
        var text: String {
            return rawValue
        }
    }
    var name: String
    var status: Status
}

extension BluetoothDevice: ListItem {
    var title: String {
        get {
            return name
        }
        set {
            //
        }
    }
    
    var subtitle: String {
        get {
            return status.text
        }
        set {
            //
        }
    }
}
