//
//  iBeaconSimulator.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/15.
//

import SwiftUI

struct iBeaconSimulator: View {
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
    
    @State private var uuid = "FDA50693-A4E2-4FB1-AFCF-C6EB07647825"
    @State private var major: UInt16 = 10009
    @State private var minor: UInt16 = 12023
    
    @State private var showImporter = false
    @State private var importediBeacons = [iBeacon]()
    @State private var showiBeaconsPicker = false
    @State private var importediBeaconSelection: iBeacon?
    
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
            } footer: {
                Text("Generate Random iBeacon")
            }
            
            Section {
                TextField("UUID", text: $uuid, prompt: Text("UUID for this iBeacon"))
                TextField("Major", value: $major, format: .number.grouping(.never))
                TextField("Major", value: $minor, format: .number.grouping(.never))
            } header: {
                Text("iBeacon Info")
            }
            
            Section {
                Toggle("Advertise", isOn: simulatting)
            } header: {
                Text("Advertise iBeacon")
            }
        }
        #if os(macOS)
        .scenePadding()
        .formStyle(.grouped)
        #endif
        .toolbar {
            Button("Import", systemImage: "square.and.arrow.down") {
                showImporter = true
            }
        }
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.text, .json]) { result in
            guard let url = try? result.get() else { return }
            guard url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }
            guard let data = try? Data(contentsOf: url) else { return }
            importediBeacons = (try? JSONDecoder().decode([iBeacon].self, from: data)) ?? []
            showiBeaconsPicker = true
        }
        .sheet(isPresented: $showiBeaconsPicker) {
            iBeaconImportSelectionSheet(importediBeacons: importediBeacons) { selection in
                uuid = selection.beaconID.uuidString
                major = selection.major
                minor = selection.minor
                self.importediBeaconSelection = nil
                self.importediBeacons = []
            }
        }
    }
}

#Preview {
    iBeaconSimulator()
}
