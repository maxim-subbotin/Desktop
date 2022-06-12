//
//  CGImage.swift
//  Desktop
//
//  Created by Maxim Subbotin on 12.06.2022.
//

import Foundation
import SwiftUI

extension CGImage {
    static func from(buffer: CVPixelBuffer?) -> CGImage? {
        guard let buffer = buffer else {
            return nil
        }
        let ciContext = CIContext()
        let ciImage = CIImage(cvImageBuffer: buffer)
        return ciContext.createCGImage(ciImage, from: ciImage.extent)
    }
    
    var uiImage: UIImage? {
        return UIImage(cgImage: self)
    }
}
