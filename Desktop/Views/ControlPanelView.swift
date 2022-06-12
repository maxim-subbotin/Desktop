//
//  ControlPanelView.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI
import AVKit
import MediaPlayer

struct ControlPanelView<Model: ControlViewModel>: View {
    enum Mode: Equatable {
        case hidden
        case normal
    }
    
    @StateObject var viewModel: Model
    
    @State var buttonSize: CGFloat = UIStyle.normal.singleButtonSize
    
    @State var offsetTopBlock = CGFloat(-400)
    @State var offsetMidBlock = CGFloat(-400)
    @State var offsetBottomBlock = CGFloat(200)
    
    @Binding var mode: Mode
    @State var brightness = UIScreen.main.brightness
    @State var volume: CGFloat = CGFloat(AVAudioSession.sharedInstance().outputVolume)
    
    @State var showNetworkView = false
    @State var showBluetoothList = false
    @State var showCamera = false
    
    @Namespace private var networkTransition
    enum Transitions: Int {
        case showFullNetworkView
        case showBluetoothList
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.01)
                .onTapGesture {
                    withAnimation(.spring(), {
                        if showBluetoothList {
                            showBluetoothList = false
                        } else if showNetworkView {
                            showNetworkView = false
                        } else {
                            mode = .hidden
                        }
                    })
                }
            if showBluetoothList {
                BluetoothView(showBluetoothList: $showBluetoothList, viewModel: viewModel)
                    .matchedGeometryEffect(id: Transitions.showBluetoothList, in: networkTransition)
            } else if showNetworkView {
                WifiFullBlockView(isExpanded: $showNetworkView, showBluetoothList: $showBluetoothList, viewModel: viewModel)
                    .matchedGeometryEffect(id: Transitions.showFullNetworkView, in: networkTransition, anchor: .topLeading)
                    .matchedGeometryEffect(id: Transitions.showBluetoothList, in: networkTransition)
            } else {
                VStack(spacing: 0) {
                    // Network (cellural, wi-fi, BT) and media blocks
                    HStack(spacing: UIStyle.normal.panelSpacing) {
                        WifiSmallBlockView(viewModel: viewModel, showBluetoothList: $showBluetoothList)
                            .matchedGeometryEffect(id: Transitions.showFullNetworkView, in: networkTransition, anchor: .topLeading)
                            .onLongPressGesture(perform: {
                                UIDevice.vibrate(style: .heavy)
                                withAnimation(.easeIn(duration: 0.2), {
                                    showNetworkView.toggle()
                                })
                            })
                        MediaBlock(title: viewModel.trackTitle)
                            .frame(width: UIStyle.normal.blockSize, height: UIStyle.normal.blockSize)
                    }
                    .padding(.top, 70)
                    .padding(.bottom, UIStyle.normal.panelSpacing)
                    .offset(x: 0, y: offsetTopBlock)
                    
                    // Brightness, Volume and screen blocks
                    MiddleBlockView(brightness: $brightness, volume: $volume, viewModel: viewModel)
                        .padding(.bottom, UIStyle.normal.panelSpacing)
                        .offset(x: 0, y: offsetMidBlock)
                    
                    Spacer()
                    
                    BottomBlockView(viewModel: viewModel)
                        .padding(.bottom, 50)
                        .offset(x: 0, y: offsetBottomBlock)
                }
                .onChange(of: mode, perform: { m in
                    withAnimation(.spring(), {
                        offsetTopBlock = m == .normal ? 0 : -400
                        offsetMidBlock = m == .normal ? 0 : -400
                        offsetBottomBlock = m == .normal ? 0 : 200
                    })
                })
                .onChange(of: brightness, perform: { b in
                    viewModel.dispatch(.setBrightness(b))
                }).onChange(of: volume, perform: { v in
                    viewModel.dispatch(.setVolume(v))
                }).onChange(of: viewModel.camera, perform: { v in
                    showCamera = v
                })
            }
        }.fullScreenCover(isPresented: $showCamera, content: {
            CameraView(isPresented: $showCamera, model: TestCameraViewModel())
                .onDisappear {
                    viewModel.dispatch(.toggleCamera)
                }
        })
    }
}

fileprivate struct MiddleBlockView<Model: ControlViewModel>: View {
    private var buttonSize: CGFloat = UIStyle.normal.singleButtonSize
    @Binding var brightness: CGFloat
    @Binding var volume: CGFloat
    @StateObject var viewModel: Model
    
    init(brightness: Binding<CGFloat>, volume: Binding<CGFloat>, viewModel: Model) {
        self._brightness = brightness
        self._volume = volume
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack(spacing: UIStyle.normal.panelSpacing) {
            VStack(spacing: UIStyle.normal.panelSpacing) {
                HStack(spacing: UIStyle.normal.panelSpacing) {
                    SingleButton(iconName: "lock.rotation",
                                 selected: viewModel.locked,
                                 callback: viewModel.dispatch(.toggleLock),
                                 style: .init(selectIconColor: .red))
                        .modifier(PanelSingleButton(size: buttonSize))
                    SingleButton(iconName: "rectangle.on.rectangle", selected: viewModel.screenShare, callback: viewModel.dispatch(.toggleScreenShare))
                        .modifier(PanelSingleButton(size: buttonSize))
                }
                RoundLabeledButton(title: "Focus", selected: viewModel.focus, callback: viewModel.dispatch(.toggleFocus))
                    .frame(width: buttonSize * 2 + UIStyle.normal.panelSpacing, height: buttonSize)
            }
            VerticalIndicatorView<BrightnessParametricView>(value: $brightness)
                .modifier(PanelVerticalSlider(width: buttonSize, height: buttonSize * 2 + UIStyle.normal.panelSpacing))
            VerticalIndicatorView<VolumeParametricView>(value: $volume)
                .modifier(PanelVerticalSlider(width: buttonSize, height: buttonSize * 2 + UIStyle.normal.panelSpacing))
        }
    }
}

fileprivate struct BottomBlockView<Model: ControlViewModel>: View {
    private var buttonSize: CGFloat = UIStyle.normal.singleButtonSize
    @StateObject var viewModel: Model
    
    init(viewModel: Model) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack(spacing: UIStyle.normal.panelSpacing) {
            SingleButton(iconName: "flashlight.on.fill", selected: viewModel.torch, callback: viewModel.dispatch(.toggleTorch))
                .modifier(PanelSingleButton(size: buttonSize))
            SingleButton(iconName: "timer", selected: viewModel.reminder, callback: viewModel.dispatch(.toggleReminder))
                .modifier(PanelSingleButton(size: buttonSize))
            SingleButton(iconName: "candybarphone", selected: viewModel.phone, callback: viewModel.dispatch(.togglePhone))
                .modifier(PanelSingleButton(size: buttonSize))
            SingleButton(iconName: "camera.fill", selected: viewModel.camera, callback: viewModel.dispatch(.toggleCamera))
                .modifier(PanelSingleButton(size: buttonSize))
        }
    }
}
