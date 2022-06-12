//
//  SunShape.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct SunShape: Shape {
    var factor: CGFloat
    private var innerRadius: CGFloat = 0.3
    private var beamStart: CGFloat = 0.5
    private var n = 8
    
    var animatableData: Double {
        get { Double(factor) }
        set { factor = CGFloat(newValue) }
    }
    
    init(factor: CGFloat) {
        self.factor = factor
    }
    
    func path(in rect: CGRect) -> Path {
        let r = min(rect.width, rect.height) / 2
        var path = Path()
        path.addEllipse(in: .init(x: rect.midX - r * innerRadius,
                                  y: rect.midY - r * innerRadius,
                                  width: 2 * r * innerRadius,
                                  height: 2 * r * innerRadius))
        let step = 2 * CGFloat.pi / CGFloat(n)
        var a: CGFloat = 0
        for _ in 0..<n {
            let r1 = r * beamStart
            let x1 = rect.midX + r1 * sin(a)
            let y1 = rect.midY + r1 * cos(a)
            let r2 = r * (beamStart + (1 - beamStart) * factor)
            let x2 = rect.midX + r2 * sin(a)
            let y2 = rect.midY + r2 * cos(a)
            path.move(to: .init(x: x1, y: y1))
            path.addLine(to: .init(x: x2, y: y2))
            a += step
        }
        return path
    }
}

struct SunShape_Preview: PreviewProvider {
    @State static var factor: Double = 30
    
    static var previews: some View {
        ZStack {
            SunShape(factor: 0.0 * factor)
                .stroke(Color.black, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .frame(width: 100, height: 100)
            Slider(value: $factor, in: 0...100)
                .offset(x: 0, y: 100)
        }
    }
}
