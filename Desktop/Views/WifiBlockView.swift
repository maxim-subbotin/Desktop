//
//  WifiBlockView.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct WifiBlockView<Model: ControlViewModel>: View {
    @Binding var isExpanded: Bool
    @StateObject var viewModel: Model
    var largeButtonSize = UIStyle.normal.expandBlockButtonSize
    
    @Namespace private var transition
    @Namespace private var btTransition
    
    @State var showBluetoothList = false

    var body: some View {
        VStack {
            if isExpanded {
                if showBluetoothList {
                    BluetoothView(showBluetoothList: $showBluetoothList, viewModel: viewModel)
                        .matchedGeometryEffect(id: "bt", in: btTransition)
                } else {
                    WifiFullBlockView(isExpanded: $isExpanded, showBluetoothList: $showBluetoothList, viewModel: viewModel)
                        .matchedGeometryEffect(id: "bt", in: btTransition)
                        .matchedGeometryEffect(id: "wifi", in: transition)
                }
            } else {
                WifiSmallBlockView(viewModel: viewModel, showBluetoothList: $showBluetoothList)
                    .matchedGeometryEffect(id: "wifi", in: transition)
            }
        }
        .onChange(of: isExpanded, perform: { expanded in
            if expanded {
                viewModel.dispatch(.getWifiInfo)
            }
        })
    }
}

struct WifiSmallBlockView<Model: ControlViewModel>: View {
    private var smallButtonSize = UIStyle.normal.roundButtonSize
    @Binding var showBluetoothList: Bool
    @StateObject var viewModel: Model
    
    init(viewModel: Model, showBluetoothList: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._showBluetoothList = showBluetoothList
    }
    
    var body: some View {
        VStack {
            HStack(spacing: UIStyle.normal.panelSpacing) {
                RoundButton(icon: Image(systemName: "airplane"),
                            selected: viewModel.flightMode,
                            callback: viewModel.dispatch(.toggleFlight),
                            style: .init(selectButtonColor: .orange))
                    .modifier(RoundBlockButton(size: smallButtonSize))
                RoundButton(icon: Image("cellural").renderingMode(.template),
                            selected: viewModel.cellular,
                            callback: viewModel.dispatch(.toggleCellular),
                            style: .init(selectButtonColor: .green))
                    .modifier(RoundBlockButton(size: smallButtonSize))
            }
            HStack(spacing: UIStyle.normal.panelSpacing) {
                RoundButton(icon: Image(systemName: "wifi"),
                            selected: viewModel.wifi,
                            callback: viewModel.dispatch(.toggleWifi))
                    .modifier(RoundBlockButton(size: smallButtonSize))
                RoundButton(icon: Image("bluetooth"),
                            selected: viewModel.bluetooth,
                            callback: viewModel.dispatch(.toggleBluetooth))
                    .modifier(RoundBlockButton(size: smallButtonSize))
                    .onLongPressGesture {
                        UIDevice.vibrate(style: .heavy)
                        withAnimation(.spring(), {
                            showBluetoothList.toggle()
                        })
                    }
            }
        }.padding(UIStyle.normal.panelSpacing)
            .background(Color.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 15))
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct BluetoothView<Model: ControlViewModel>: View {
    @Binding var showBluetoothList: Bool
    @StateObject var viewModel: Model
    
    init(showBluetoothList: Binding<Bool>, viewModel: Model) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._showBluetoothList = showBluetoothList
    }
    
    var body: some View {
        BluetoothListView(viewModel: viewModel)
            .frame(width: 300, height: 400)
            .background(Color.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 15))
    }
}

struct WifiFullBlockView<Model: ControlViewModel>: View {
    @Binding var isExpanded: Bool
    @Binding var showBluetoothList: Bool
    @StateObject var viewModel: Model
    
    init(isExpanded: Binding<Bool>, showBluetoothList: Binding<Bool>, viewModel: Model) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isExpanded = isExpanded
        self._showBluetoothList = showBluetoothList
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: UIStyle.normal.panelSpacing) {
                RoundTextButton(icon: Image(systemName: "airplane"),
                            title: "Airplane Mode",
                            subtitle: viewModel.flightMode.onOff,
                            selected: viewModel.flightMode,
                            callback: viewModel.dispatch(.toggleFlight),
                            style: .init(selectButtonColor: .orange))
                    .modifier(NetworkRoundTextButton())
                RoundTextButton(icon: Image("cellural").renderingMode(.template),
                            title: "Cellular Data",
                            subtitle: viewModel.cellular.onOff,
                            selected: viewModel.cellular,
                            callback: viewModel.dispatch(.toggleCellular),
                            style: .init(selectButtonColor: .green))
                    .modifier(NetworkRoundTextButton())
            }.padding(.top, 20)
            HStack(spacing: UIStyle.normal.panelSpacing) {
                RoundTextButton(icon: Image(systemName: "wifi"),
                            title: "Wi-fi",
                            subtitle: viewModel.ssid,
                            selected: viewModel.wifi,
                            callback: viewModel.dispatch(.toggleWifi))
                    .modifier(NetworkRoundTextButton())
                RoundTextButton(icon: Image("bluetooth"),
                            title: "Bluetooth",
                            subtitle: viewModel.bluetooth.onOff,
                            selected: viewModel.bluetooth,
                            callback: viewModel.dispatch(.toggleBluetooth))
                    .modifier(NetworkRoundTextButton())
                    .onLongPressGesture {
                        UIDevice.vibrate(style: .heavy)
                        withAnimation(.spring(), {
                            showBluetoothList.toggle()
                        })
                    }
            }
            HStack(spacing: UIStyle.normal.panelSpacing) {
                RoundTextButton(icon: Image(systemName: "airplayaudio"),
                            title: "AirDrop",
                            subtitle: viewModel.airdrop.onOff,
                            selected: viewModel.airdrop,
                            callback: viewModel.dispatch(.toggleAirdrop))
                    .modifier(NetworkRoundTextButton())
                RoundTextButton(icon: Image(systemName: "personalhotspot"),
                            title: "Personal Hotspot",
                            subtitle: viewModel.hotspot.onOff,
                            selected: viewModel.hotspot,
                            callback: viewModel.dispatch(.toggleHotspot))
                    .modifier(NetworkRoundTextButton())
            }.padding(.bottom, 20)
        }
        .background(Color.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 15))
        .onAppear() {
            viewModel.dispatch(.getWifiInfo)
        }
    }
}
