//
//  UIStyle.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import UIKit

struct UIStyle {
    var singleButtonSize: CGFloat = 70
    var roundButtonSize: CGFloat = 55
    var singleButtonIconPadding: CGFloat = 20
    var roundButtonIconPadding: CGFloat = 15
    var panelSpacing: CGFloat = 15
    var blockButtonPadding: CGFloat = 10
    var expandBlockButtonSize: CGFloat = 140
    
    var blockSize: CGFloat {
        return singleButtonSize * 2 + panelSpacing
    }
    
    private init() {
        
    }
    
    static var normal = UIStyle()
}
