//
//  VerticalIndicatorView.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct VerticalIndicatorView<Icon>: View where Icon : ParametricView {
    @Binding var value: CGFloat
    
    @State var startValue: CGFloat? = nil
    func dragGesture(height: CGFloat) -> some Gesture {
        let gesture = DragGesture()
            .onChanged({ val in
                if startValue == nil {
                    startValue = value
                }
                let dy = val.startLocation.y - val.location.y
                let a = dy / height
                value = max(min(startValue! + a, 1), 0)
            })
            .onEnded({ val in
                startValue = nil
            })
        return gesture
    }
    
    var body: some View {
        GeometryReader { geom in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.black)
                    .opacity(0.5)
                Rectangle()
                    .fill(Color.white)
                    .frame(height: geom.size.height * value)
                    .opacity(0.65)
                Icon(value: value)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.black)
                    .opacity(0.7)
                    .padding(.bottom, 15)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .gesture(dragGesture(height: geom.size.height))
        }
    }
}
