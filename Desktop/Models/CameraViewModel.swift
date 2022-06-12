//
//  CameraViewModel.swift
//  Desktop
//
//  Created by Maxim Subbotin on 12.06.2022.
//

import Foundation
import SwiftUI

protocol CameraViewModel: ObservableObject {
    var frame: CGImage? { get }
    var angle: CGFloat { get }
    var angleLabel: String { get }
}

class TestCameraViewModel: CameraViewModel {
    @Published private(set) var frame: CGImage?
    @Published private(set) var angle: CGFloat = 0
    @Published private(set) var angleLabel: String = ""
    private let frameManager = FrameProvider()
    private let accManager = AccelerometerProvider()

    init() {
        setupSubscriptions()
    }

    func setupSubscriptions() {
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                return CGImage.from(buffer: buffer)
            }
            .assign(to: &$frame)
        accManager.$tetha
            .receive(on: RunLoop.main)
            .map { v in
                return v
            }.assign(to: &$angle)
        accManager.$tetha
            .receive(on: RunLoop.main)
            .map { v in
                var degrees = Angle(radians: v).degrees
                if degrees > 90 {
                    degrees = abs(180 - degrees)
                }
                return String("\(Int(degrees))°")
            }.assign(to: &$angleLabel)
    }
}
