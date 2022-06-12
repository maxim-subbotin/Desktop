//
//  AccelerometerProvider.swift
//  Desktop
//
//  Created by Maxim Subbotin on 12.06.2022.
//

import Foundation
import CoreMotion
import Combine
import SwiftUI

class AccelerometerProvider {
    @Published var tetha: CGFloat = 0
    @Published var phi: CGFloat = 0
    
    let manager = CMMotionManager()
    
    private var queue = OperationQueue()
    
    init() {
        manager.startAccelerometerUpdates(to: queue, withHandler: { data, error in
            if let acc = data {
                let r = sqrt(acc.acceleration.x * acc.acceleration.x +
                             acc.acceleration.y * acc.acceleration.y +
                             acc.acceleration.z * acc.acceleration.z)
                self.tetha = CGFloat.pi / 2 - atan(acc.acceleration.y / acc.acceleration.x)
                self.phi = asin(acc.acceleration.z / r)
            }
        })
    }
    
    deinit {
        manager.stopAccelerometerUpdates()
    }
}
