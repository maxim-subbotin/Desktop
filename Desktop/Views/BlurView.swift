//
//  BlurView.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import UIKit
import SwiftUI

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    public init(style s: UIBlurEffect.Style) {
        self.style = s
    }

    public func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    public func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {

    }

}
