//
//  DesktopView.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

/**
 Desktop includes wallpaper and control panel
 */
struct DesktopView: View {
    @State var blurFactor: CGFloat = 0
    @State var panelMode: ControlPanelView<TestControlViewModel>.Mode = .hidden
    
    /**
     hide = false if we want to show control panel, true - if we want to hide it
     */
    @State private var hide: Bool?
    
    @ObservedObject var controlModel = TestControlViewModel()
    
    private var maxBlurFactor: CGFloat = 30
    private var panelModelThreshold = CGFloat(50)
        
    var dragGesture: some Gesture {
        let gesture = DragGesture()
                        .onChanged({ val in
                            if hide == nil {
                                hide = panelMode == .normal
                            }
                            let d = val.startLocation.distance(val.location)
                            if hide! {
                                blurFactor = (d > 2 * panelModelThreshold) ? 0 : maxBlurFactor * (1 - 0.5 * d / panelModelThreshold)
                                panelMode = (d > panelModelThreshold) ? .hidden : .normal
                            } else {
                                blurFactor = (d > panelModelThreshold) ? maxBlurFactor : maxBlurFactor * (d / panelModelThreshold)
                                panelMode = (d > panelModelThreshold) ? .normal : .hidden
                            }
                        })
                        .onEnded({ val in
                            guard let hide = hide else {
                                return
                            }

                            let d = val.startLocation.distance(val.location)
                            if d < panelModelThreshold {
                                withAnimation(.easeIn(duration: 0.25), {
                                    blurFactor = hide ? maxBlurFactor : 0
                                })
                                panelMode = hide ? .normal : .hidden
                            } else {
                                withAnimation(.easeIn(duration: 0.25), {
                                    blurFactor = hide ? 0 : maxBlurFactor
                                })
                                panelMode = hide ? .hidden : .normal
                            }
                            self.hide = nil
                        })
        return gesture
    }
    
    var body: some View {
        ZStack {
            Image("wallpaper")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: blurFactor)
                .gesture(dragGesture)
            if blurFactor > 0 {
                ControlPanelView(viewModel: controlModel, mode: $panelMode)
            }
        }.onChange(of: panelMode, perform: { mode in
            if mode == .hidden {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    withAnimation(.easeIn(duration: 0.25), {
                        blurFactor = 0
                    })
                })
            }
        })
    }
}
