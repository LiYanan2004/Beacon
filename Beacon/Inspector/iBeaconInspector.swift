//
//  iBeaconInspector.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/15.
//

import SwiftUI

struct iBeaconInspector: View {
    @State private var manager = iBeaconInspectionManager()
    
    // MARK: Export
    @State private var exportedJSON = ""
    @State private var showExporter = false
    
    var body: some View {
        Form {
            if manager.ibeacons.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                ForEach(manager.ibeacons) { ibeacon in
                    Section {
                        LabeledContent("Device UUID", value: ibeacon.deviceID?.uuidString ?? "<Unknown>")
                        LabeledContent("iBeacon UUID", value: ibeacon.beaconID.uuidString)
                        LabeledContent("Major", value: ibeacon.major.formatted(.number.grouping(.never)))
                        LabeledContent("Minor", value: ibeacon.minor.formatted(.number.grouping(.never)))
                    }
                }
            }
        }
        .formStyle(.grouped)
        .toolbar(content: toolbar)
        .fileExporter(isPresented: $showExporter, item: exportedJSON, defaultFilename: "iBeacons_\(Date.now.ISO8601Format())") { _ in }
        .fileDialogConfirmationLabel(Text("Export"))
    }
}

extension iBeaconInspector {
    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem {
            Button("Export", systemImage: "square.and.arrow.up") {
                let json = try? JSONEncoder().encode(manager.ibeacons.elements)
                guard let json else { return }
                
                let jsonString = String(data: json, encoding: .utf8)
                guard let jsonString else { return }
                exportedJSON = jsonString
                showExporter = true
            }
        }
        
        ToolbarItem(placement: .cancellationAction) {
            Button(
                "Reset",
                systemImage: "arrow.clockwise",
                action: manager.restart
            )
        }
    }
}

#Preview {
    iBeaconInspector()
}
