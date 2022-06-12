//
//  CameraView.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct CameraView<Model: CameraViewModel>: View {
    @Binding var isPresented: Bool
    @StateObject var model: Model
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                GeometryReader { geom in
                    if model.frame?.uiImage != nil {
                        Image(uiImage: model.frame!.uiImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geom.size.width, height: geom.size.height, alignment: .center)
                    } else {
                        Color.black
                    }
                }
                Text(model.angleLabel)
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .padding(3)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 3))
                    .offset(x: 0, y: -20)
                AccView(angle: model.angle)
            }
            BottomBar(callback: on(bottomAction:))
        }.edgesIgnoringSafeArea(.all)
    }
    
    private func on(bottomAction action: BottomBar.Action) {
        switch action {
        case .back:
            withAnimation {
                isPresented.toggle()
            }
        }
    }
}

fileprivate struct AccView: View {
    var angle: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: 200, height: 2)
            CircleShape()
                .stroke(Color.green, lineWidth: 2)
                .frame(width: 250, height: 200)
                .rotationEffect(Angle(radians: angle))
        }
    }
}

fileprivate struct CircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let r = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()
        path.move(to: .init(x: rect.midX - r, y: rect.midY))
        path.addLine(to: .init(x: rect.midX - r - 20, y: rect.midY))
        path.move(to: .init(x: rect.midX + r, y: rect.midY))
        path.addLine(to: .init(x: rect.midX + r + 20, y: rect.midY))
        let x1 = center.x + r * cos(CGFloat(Angle(degrees: -20).radians))
        let y1 = center.y + r * sin(CGFloat(Angle(degrees: -20).radians))
        path.move(to: .init(x: x1, y: y1))
        path.addArc(center: center, radius: r, startAngle: .degrees(-20), endAngle: .degrees(20), clockwise: false)
        
        let x2 = center.x + r * cos(CGFloat(Angle(degrees: 160).radians))
        let y2 = center.y + r * sin(CGFloat(Angle(degrees: 160).radians))
        path.move(to: .init(x: x2, y: y2))
        path.addArc(center: center, radius: r, startAngle: .degrees(160), endAngle: .degrees(200), clockwise: false)
        return path
    }
}

fileprivate struct BottomBar: View {
    enum Action {
        case back
    }
    typealias Callback = (Action) -> ()
    
    var callback: Callback
    
    var body: some View {
        HStack {
            Button(action: {
                callback(.back)
            }, label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white)
                    .frame(width: 25, height: 25)
            })
            Spacer()
        }
        .padding(15)
        .padding(.bottom, 20)
        .background(.thinMaterial)
    }
}
