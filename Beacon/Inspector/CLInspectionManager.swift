//
//  CLInspectionManager.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/16.
//

import Foundation
import Observation
import CoreLocation
import CoreBluetooth

@Observable
class CLInspectionManager: NSObject {
    private var constraint: CLBeaconIdentityConstraint!
    private var beaconRegion: CLBeaconRegion!
    private var locationManager = CLLocationManager()
    
    var isScanning = false
    var discoveredBeacons = [iBeacon]()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startScanning(uuid: UUID) {
        discoveredBeacons = []
        locationManager.requestWhenInUseAuthorization()
        
        constraint = CLBeaconIdentityConstraint(uuid: uuid)
        beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: uuid.uuidString)
        locationManager.startMonitoring(for: beaconRegion)
        isScanning = true
    }
    
    func stopScanning() {
        isScanning = false
        guard let beaconRegion else { return }
        locationManager.stopMonitoring(for: beaconRegion)
    }
}

extension CLInspectionManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let beaconRegion = region as? CLBeaconRegion
        if state == .inside {
            // Start ranging when inside a region.
            manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        } else {
            // Stop ranging when not inside a region.
            manager.stopRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        discoveredBeacons = beacons.map {
            iBeacon(
                beaconID: $0.uuid,
                major: UInt16(truncating: $0.major),
                minor: UInt16(truncating: $0.minor)
            )
        }
    }
}
