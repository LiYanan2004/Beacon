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

@Observable
class iBeaconSimulatorManager: NSObject, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager!
    private var region: CLBeaconRegion!
    
    var isPoweredOn = false
    var isAdvertising = false
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    deinit {
        peripheralManager.stopAdvertising()
    }
    
    func startSimulatting(uuid: String, major: UInt16, minor: UInt16) {
        peripheralManager.stopAdvertising()
        region = CLBeaconRegion(uuid: UUID(uuidString: uuid)!, major: major, minor: minor, identifier: Bundle.main.bundleIdentifier!)
        let data = region.peripheralData(withMeasuredPower: nil) as? [String: Any]
        peripheralManager.startAdvertising(data)
    }
    
    func startSimulatting(data: Data) {
        let data = [
            CBAdvertisementDataManufacturerDataKey : data as NSData
        ]
        peripheralManager.startAdvertising(data)
    }
    
    func stopSimulatting() {
        peripheralManager.stopAdvertising()
        isAdvertising = false
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        isPoweredOn = peripheral.state == .poweredOn
        if peripheral.state != .poweredOn {
            stopSimulatting()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: (any Error)?) {
        if let error {
            print(error)
        }
        
        if isPoweredOn {
            isAdvertising = peripheral.isAdvertising
        } else {
            stopSimulatting()
        }
    }
}
