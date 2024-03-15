//
//  iBeaconInspector.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/15.
//

import SwiftUI

struct iBeaconInspector: View {
    @State private var manager = iBeaconInspectionManager()
    
    var body: some View {
        Form {
            if manager.ibeacons.isEmpty {
                ProgressView()
            } else {
                ForEach(manager.ibeacons) { ibeacon in
                    Section {
                        LabeledContent("UUID", value: ibeacon.beaconID.uuidString)
                        LabeledContent("Major", value: ibeacon.major.formatted(.number.grouping(.never)))
                        LabeledContent("Minor", value: ibeacon.minor.formatted(.number.grouping(.never)))
                    }
                }
            }
        }
        .formStyle(.grouped)
        .alternatingRowBackgrounds()
    }
}

#Preview {
    iBeaconInspector()
}
