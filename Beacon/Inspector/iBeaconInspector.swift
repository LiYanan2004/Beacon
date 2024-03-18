//
//  iBeaconInspector.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/15.
//

import SwiftUI

struct iBeaconInspector: View {
    @State private var cbmanager = CBInspectionManager()
    @State private var clmanager = CLInspectionManager()
    @State private var inspectionMode: InspectionMode = .ibeacon
    
    @State private var uuid = iBeacon.example.beaconID.uuidString
    private var iBeaconScanning: Binding<Bool> {
        Binding<Bool> {
            clmanager.isScanning
        } set: { isScanning in
            if isScanning {
                if let uuid = UUID(uuidString: self.uuid) {
                    clmanager.startScanning(uuid: uuid)
                }
            } else {
                clmanager.stopScanning()
            }
        }
    }
    
    // MARK: Export
    @State private var exportedJSON = ""
    @State private var showExporter = false
    
    var body: some View {
        Group {
            switch inspectionMode {
            case .common: commonInspector
            case .ibeacon: ibeaconInspector
            }
        }
        .fileExporter(isPresented: $showExporter, item: exportedJSON, defaultFilename: "iBeacon_\(Date.now.ISO8601Format())") { _ in }
        .fileDialogConfirmationLabel(Text("Export"))
        .formStyle(.grouped)
        .toolbar(content: toolbar)
    }
    
    private var ibeaconInspector: some View {
        Form {
            Section {
                TextField("UUID", text: $uuid)
            } header: {
                Text("iBeacon UUID")
            }
            
            Section {
                Toggle("Scan", isOn: iBeaconScanning)
            } header: {
                Text("Discover")
            } footer: {
                Text("Discover iBeacons with specified UUID.")
            }
            
            if iBeaconScanning.wrappedValue {
                Section {
                    if clmanager.discoveredBeacons.isEmpty {
                        ProgressView()
                    } else {
                        ForEach(clmanager.discoveredBeacons) { ibeacon in
                            HStack {
                                Group {
                                    Text("MAJOR")
                                        .foregroundStyle(.secondary)
                                    + Text(ibeacon.major, format: .number.grouping(.never))
                                }
                                .padding(4)
                                .background(.red.quaternary, in: .rect(cornerRadius: 5))
                                
                                Group {
                                    Text("MINOR")
                                        .foregroundStyle(.secondary)
                                    + Text(ibeacon.minor, format: .number.grouping(.never))
                                }
                                .padding(4)
                                .background(.brown.quaternary, in: .rect(cornerRadius: 8))
                            }
                            .fontDesign(.rounded)
                        }
                    }
                } header: {
                    Text("Discovered iBeacons")
                }
            }
        }
        .onDisappear(perform: clmanager.stopScanning)
    }
    
    private var commonInspector: some View {
        Form {
            if cbmanager.ibeacons.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                ForEach(cbmanager.ibeacons) { ibeacon in
                    Section {
                        LabeledContent("UUID", value: ibeacon.beaconID.uuidString)
                        LabeledContent("Major", value: ibeacon.major.formatted(.number.grouping(.never)))
                        LabeledContent("Minor", value: ibeacon.minor.formatted(.number.grouping(.never)))
                    }
                }
            }
        }
        .onAppear(perform: cbmanager.startScanning)
        .onDisappear(perform: cbmanager.stopScanning)
    }
}

extension iBeaconInspector {
    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem {
            Button("Export", systemImage: "square.and.arrow.up") {
                let json = switch inspectionMode {
                case .common: try? JSONEncoder().encode(cbmanager.ibeacons.elements)
                case .ibeacon: try? JSONEncoder().encode(clmanager.discoveredBeacons)
                }
                guard let json else { return }
                
                let jsonString = String(data: json, encoding: .utf8)
                guard let jsonString else { return }
                exportedJSON = jsonString
                showExporter = true
            }
        }
        
        #if os(macOS)
        ToolbarItemGroup(placement: .principal) {
            Spacer()
            inspectionModePicker
            Spacer()
        }
        #else
        ToolbarItem(placement: .principal) {
            inspectionModePicker
        }
        #endif
        
        if inspectionMode == .common {
            ToolbarItem(placement: .cancellationAction) {
                Button(
                    "Reset",
                    systemImage: "arrow.clockwise",
                    action: cbmanager.restart
                )
            }
        }
    }
    
    private var inspectionModePicker: some View {
        Picker("Inspection Mode", selection: $inspectionMode) {
            Text("iBeacon").tag(InspectionMode.ibeacon)
            Text("Common").tag(InspectionMode.common)
        }
        .pickerStyle(.inline)
        .fixedSize()
    }
    
    private enum InspectionMode {
        case common, ibeacon
    }
}

#Preview {
    iBeaconInspector()
}
