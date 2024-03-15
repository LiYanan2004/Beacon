//
//  iBeaconSimulationManager.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/15.
//

import Foundation
import Observation
import CoreLocation
import CoreBluetooth

class iBeaconSimulatorManager: NSObject, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager!
    private var region: CLBeaconRegion!
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    deinit {
        peripheralManager.stopAdvertising()
    }
    
    @discardableResult
    func startSimulatting(uuid: String, major: UInt16, minor: UInt16) -> Bool {
        peripheralManager.stopAdvertising()
        region = CLBeaconRegion(uuid: UUID(uuidString: uuid)!, major: major, minor: minor, identifier: Bundle.main.bundleIdentifier!)
        let data = region.peripheralData(withMeasuredPower: nil) as? [String: Any]
        peripheralManager.startAdvertising(data)
        
        return peripheralManager.isAdvertising
    }
    
    func stopSimulatting() {
        peripheralManager.stopAdvertising()
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state != .poweredOn {
            peripheral.stopAdvertising()
        }
    }
}
