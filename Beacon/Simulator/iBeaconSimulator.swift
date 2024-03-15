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
    var simulatting: Binding<Bool> {
        Binding<Bool> {
            manager.isAdvertising
        } set: { simulatting in
            if simulatting {
                manager.startSimulatting(uuid: uuid, major: major, minor: minor)
            } else {
                manager.stopSimulatting()
            }
        }
    }
    
    var body: some View {
        Form {
            Section {
                LabeledContent("Peripheral Status", value: manager.isPoweredOn ? "On" : "Off")
            }
            
            Section {
                Button("Randomize") {
                    uuid = UUID().uuidString
                    major = UInt16.random(in: 0..<UInt16.max)
                    minor = UInt16.random(in: 0..<UInt16.max)
                }
            }
            
            Section {
                TextField("UUID", text: $uuid, prompt: Text("UUID for this iBeacon"))
                TextField("Major", value: $major, format: .number.grouping(.never))
                TextField("Major", value: $minor, format: .number.grouping(.never))
            }
            
            Section {
                Toggle("Simulate", isOn: simulatting)
            }
        }
    }
    
    func startSimulatting() {
        
    }
}

#Preview {
    iBeaconSimulator()
}
