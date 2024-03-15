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
    }
    
    private var tabview: some View {
        TabView(selection: $selection) {
            NavigationStack {
                iBeaconSimulator()
            }
            .tag(Tab.simulator)
            .tabItem {
                Label("Simulator", systemImage: "wave.3.forward")
            }
            NavigationStack {
                iBeaconInspector()    
            }
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
