//
//  CBInspectionManager.swift
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
class CBInspectionManager: NSObject {
    var centralManager: CBCentralManager!
    var ibeacons = OrderedSet<iBeacon>()
    
    var isPoweredOn = false
    var isScanning = false
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    deinit {
        stopScanning()
    }
    
    func startScanning() {
        centralManager.stopScan()
        if isPoweredOn {
            centralManager.scanForPeripherals(withServices: nil)
            isScanning = true
        }
    }
    
    func stopScanning() {
        centralManager.stopScan()
        isScanning = false
    }
    
    func restart() {
        centralManager.stopScan()
        ibeacons.removeAll()
        if isPoweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
}

extension CBInspectionManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isPoweredOn = central.state == .poweredOn
        if !isPoweredOn {
            stopScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let advData: NSData? = advertisementData[CBAdvertisementDataManufacturerDataKey] as? NSData
        guard let advData else { return }
        
        guard var ibeacon = iBeacon(manufacturerData: advData) else { return }
        ibeacons.updateOrInsert(ibeacon, at: 0)
    }
}
