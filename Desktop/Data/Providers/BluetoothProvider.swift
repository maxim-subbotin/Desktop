//
//  BluetoothProvider.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

class BluetoothProvider {
    enum BTError: Error {
        case networkAccessError
    }
    
    func getBTDevices(callback: @escaping (Result<[BluetoothDevice], Error>) -> ())  {
        // TODO: get list of real devices
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0, execute: {
            let f = Int.random(in: 0...10)
            if f > 2 {
                let count = Int.random(in: 1...5)
                let devices = self.generateDevices(count)
                callback(.success(devices))
            } else {
                callback(.failure(BTError.networkAccessError))
            }
        })

    }
    
    private func generateDevices(_ n: Int) -> [BluetoothDevice] {
        var n = n
        var names = ["Plantronics Voyager 5200",
                     "Sony MBH22",
                     "Plantronics Explorer 500",
                     "Jabra Stealth",
                     "Sennheiser Presence UC",
                     "Jabra Steel",
                     "Plantronics M70",
                     "Jabra Wave",
                    "BlueParrot S450-XT",
                    "Apple Airpods"]
        n = min(n, names.count)
        names.shuffle()
        let titles = Array(names[0..<n])
        return titles.map({ BluetoothDevice(name: $0, status: Bool.random() ? .connected : .disconnected) })
    }
}
