//
//  ParametricView.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

protocol ParametricView: View {
    /**
     value = [0, 1]
     */
    var value: CGFloat { get set }
    
    init(value: CGFloat)
}

struct BrightnessParametricView: ParametricView {
    var value: CGFloat
    @State var an: CGFloat
    
    init(value: CGFloat) {
        self.value = value
        self._an = State(wrappedValue: value)
    }
    
    var body: some View {
        GeometryReader { geom in
            ZStack {
                icon(size: geom.size, value: value)
            }
        }
    }
    
    func icon(size: CGSize, value: CGFloat) -> some View {
        SunShape(factor: value)
            .stroke(Color.black, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
            .frame(width: size.width, height: size.height)
    }
}

struct VolumeParametricView: ParametricView {
    var value: CGFloat
    
    init(value: CGFloat) {
        self.value = value
    }
    
    var body: some View {
        Image(systemName: icon(byValue: value))
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
    
    func icon(byValue v: CGFloat) -> String {
        if v == 0 {
            return "speaker.slash.fill"
        } else if v < 0.3 {
            return "speaker.wave.1.fill"
        } else if v < 0.7 {
            return "speaker.wave.2.fill"
        } else if v <= 1 {
            return "speaker.wave.3.fill"
        } else {
            return "speaker.badge.exclamationmark.fill"
        }
    }
}
