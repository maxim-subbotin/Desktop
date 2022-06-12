//
//  TorchProvider.swift
//  Desktop
//
//  Created by Maxim Subbotin on 12.06.2022.
//

import Foundation
import AVKit

class TorchProvider {
    enum TorchError: Error {
        case torchCouldNotBeUsed
        case torchIsUnavailable
    }
    
    func turnTorch(on: Bool) -> Result<Bool, TorchError> {
        guard let device = AVCaptureDevice.default(for: .video) else {
            return .failure(.torchIsUnavailable)
        }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                return .failure(.torchCouldNotBeUsed)
            }
        } else {
            return .failure(.torchIsUnavailable)
        }
        return .success(true)
    }
}
