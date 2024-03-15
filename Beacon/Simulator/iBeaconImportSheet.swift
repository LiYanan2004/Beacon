//
//  iBeaconImportSelectionSheet.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/16.
//

import SwiftUI

struct iBeaconImportSelectionSheet: View {
    var importediBeacons: [iBeacon]
    var completion: (iBeacon) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var importediBeaconSelection: iBeacon?
    
    var body: some View {
        NavigationStack {
            List(importediBeacons, selection: $importediBeaconSelection) { ibeacon in
                VStack(alignment: .leading) {
                    Text(ibeacon.beaconID.uuidString)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .truncationMode(.middle)
                    
                    Group {
                        Text(ibeacon.major, format: .number.grouping(.never)) +
                        Text("(major) - ") +
                        Text(ibeacon.minor, format: .number.grouping(.never)) +
                        Text("(minor)")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .tag(ibeacon)
            }
            .navigationTitle("Import iBeacon")
            .toolbar {
                Button(importediBeaconSelection == nil ? "Cancel" : "Import") {
                    dismiss()
                    
                    guard let importediBeaconSelection else { return }
                    completion(importediBeaconSelection)
                }
            }
        }
    }
}

#Preview {
    iBeaconImportSelectionSheet(importediBeacons: []) { selection in
        print(selection)
    }
}
