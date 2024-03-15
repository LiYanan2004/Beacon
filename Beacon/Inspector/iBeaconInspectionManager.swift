//
//  iBeaconInspectionManager.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/15.
//

import Foundation
import Observation
import CoreLocation
import CoreBluetooth
import Collections

@Observable
class iBeaconInspectionManager: NSObject {
    var centralManager: CBCentralManager!
    var ibeacons = OrderedSet<iBeacon>()
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    deinit {
        centralManager.stopScan()
    }
}

extension iBeaconInspectionManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let advData: NSData? = advertisementData["kCBAdvDataManufacturerData"] as? NSData
        guard let advData else { return }
        
        guard let ibeacon = iBeacon(manufacturerData: advData) else { return }
        ibeacons.updateOrInsert(ibeacon, at: 0)
    }
}
