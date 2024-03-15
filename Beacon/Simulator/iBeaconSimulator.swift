//
//  iBeaconSimulator.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/15.
//

import SwiftUI

struct iBeaconSimulator: View {
    @State private var uuid = "FDA50693-A4E2-4FB1-AFCF-C6EB07647825"
    @State private var major: UInt16 = 10009
    @State private var minor: UInt16 = 12023
    
    @State private var manager = iBeaconSimulatorManager()
    @State private var simulatting = false
    
    var body: some View {
        Form {
            Section {
                Button("Randomize") {
                    uuid = UUID().uuidString
                    major = UInt16.random(in: 0..<UInt16.max)
                    minor = UInt16.random(in: 0..<UInt16.max)
                }
            }
            
            Section {
                TextField("UUID", text: $uuid, prompt: Text("UUID for this iBeacon"))
                TextField("Major", value: $major, format: .number)
                TextField("Major", value: $minor, format: .number)
            }
            
            Section {
                Toggle("Simulate", isOn: $simulatting)
                    .onChange(of: simulatting) {
                        if simulatting {
                            simulatting = manager.startSimulatting(uuid: uuid, major: major, minor: minor)
                        } else {
                            manager.stopSimulatting()
                        }
                    }
            }
        }
    }
    
    func startSimulatting() {
        
    }
}

#Preview {
    iBeaconSimulator()
}
