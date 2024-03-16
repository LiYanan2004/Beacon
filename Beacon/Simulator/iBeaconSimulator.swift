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
                manager.startSimulatting(
                    uuid: beacon.beaconID.uuidString,
                    major: beacon.major,
                    minor: beacon.minor
                )
            } else {
                manager.stopSimulatting()
            }
        }
    }
    
    @State private var beacon = iBeacon.example
    @State private var uuid = iBeacon.example.beaconID.uuidString
    @State private var showImporter = false
    @State private var importediBeacons = [iBeacon]()
    @State private var showiBeaconsPicker = false
    
    var body: some View {
        Form {
            Section {
                LabeledContent("Peripheral Status", value: manager.isPoweredOn ? "On" : "Off")
            }
            
            Section {
                Button("Randomize") {
                    beacon = .random
                    uuid = beacon.beaconID.uuidString
                }
            } footer: {
                Text("Generate Random iBeacon")
            }
            
            Section {
                TextField("UUID", text: $uuid, prompt: Text("UUID for this iBeacon"))
                    .onSubmit {
                        if let uuid = UUID(uuidString: uuid) {
                            beacon.beaconID = uuid
                        } else {
                            self.uuid = beacon.beaconID.uuidString
                        }
                    }
                TextField("Major", value: $beacon.major, format: .number.grouping(.never))
                TextField("Major", value: $beacon.minor, format: .number.grouping(.never))
            } header: {
                Text("iBeacon Info")
            }
            .onChange(of: beacon, manager.stopSimulatting)
            
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
                beacon = selection
                self.importediBeacons = []
            }
        }
    }
    
    enum SimulationType {
        case apple, data
    }
}

#Preview {
    iBeaconSimulator()
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
