//
//  ContentView.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/14.
//

import SwiftUI

struct ContentView: View {
    private enum Tab {
        case inspector, simulator
    }
    @State private var selection: Tab? = .inspector
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        switch horizontalSizeClass {
        case .compact: tabview
        default: navigationSplitView
        }
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//            Toggle("Toggle", isOn: $isOn)
//                .onChange(of: isOn, initial: true) {
//                    if beacon1.state == .poweredOn {
//                        beacon1.stopAdvertising()
//                        beacon2.stopAdvertising()
//                        if isOn {
//                            let uuid = UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!
////                            let (major1, minor1) = (UInt16(10009), UInt16(12023))
////                            let constraint1 = CLBeaconIdentityConstraint(uuid: uuid, major: major1, minor: minor1)
////                            region1 = CLBeaconRegion(beaconIdentityConstraint: constraint1, identifier: UUID().uuidString)
////                            let data1 = region1!.peripheralData(withMeasuredPower: nil) as? [String: Any]
////                            beacon1.startAdvertising(data1)
////                            print(data1)
//                            let (major2, minor2) = (UInt16(10090), UInt16(57622))
//                            let constraint2 = CLBeaconIdentityConstraint(uuid: uuid, major: major2, minor: minor2)
//                            region2 = CLBeaconRegion(beaconIdentityConstraint: constraint2, identifier: UUID().uuidString)
//                            let data2 = region2!.peripheralData(withMeasuredPower: nil) as? [String: Any]
//                            beacon2.startAdvertising(data2)
//                            print(beacon2)
//                        }
//                    } else {
//                        isOn = false
//                    }
//                }
//        }
//        .padding()
    }
    
    private var tabview: some View {
        TabView(selection: $selection) {
            iBeaconSimulator()
                .tag(Tab.simulator)
                .tabItem {
                    Label("Simulator", systemImage: "wave.3.forward")
                }
            iBeaconInspector()
                .tag(Tab.inspector)
                .tabItem {
                    Label("Inspector", systemImage: "scope")
                }
        }
    }
    
    private var navigationSplitView: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Label("Simulator", systemImage: "wave.3.forward")
                    .tag(Tab.simulator)
                Label("Inspector", systemImage: "scope")
                    .tag(Tab.inspector)
            }
        } detail: {
            switch selection {
            case .inspector: iBeaconInspector()
            case .simulator: iBeaconSimulator()
            default: ContentUnavailableView("Select", systemImage: "wave.3.forward")
            }
        }
    }
}

#Preview {
    ContentView()
}
