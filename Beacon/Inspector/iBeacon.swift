//
//  iBeacon.swift
//  Beacon
//
//  Created by LiYanan2004 on 2024/3/15.
//

import Foundation
import CoreTransferable

struct iBeacon: Sendable, Codable, Identifiable, Hashable {
    public var id: String { "\(beaconID.uuidString)-\(major)-\(minor)" }
    var beaconID: UUID
    var major: UInt16
    var minor: UInt16
    
    var manufacturerData: Data?
    var deviceID: UUID?
}

extension iBeacon: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .json)
    }
}

extension iBeacon {
    init?(manufacturerData: NSData) {
        let id = iBeacon.extractUUID(data: manufacturerData)
        let major = iBeacon.extractMajor(data: manufacturerData)
        let minor = iBeacon.extractMinor(data: manufacturerData)
        
        guard let id, let major, let minor else { return nil }
        
        self.beaconID = id
        self.major = major
        self.minor = minor
        self.manufacturerData = manufacturerData as Data
    }
    
    // Data structure of iBeacon
    // 4C00 02 15 585CDE931B0142CC9A1325009BEDC65E 0000 0000 C5
    // <company identifier (2 bytes)> <type (1 byte)> <data length (1 byte)>
    // <uuid (16 bytes)> <major (2 bytes)> <minor (2 bytes)> <RSSI @ 1m>
    fileprivate static func extractUUID(data: NSData) -> UUID? {
        load(data: data, range: NSRange(location: 4, length: 16), as: UUID.self)
    }
    
    fileprivate static func extractMajor(data: NSData) -> UInt16? {
        let value = load(data: data, range: NSRange(location: 20, length: 2), as: UInt16.self)
        guard let value else { return nil }
        return value << 8 | value >> 8
    }
    
    fileprivate static func extractMinor(data: NSData) -> UInt16? {
        let value = load(data: data, range: NSRange(location: 22, length: 2), as: UInt16.self)
        guard let value else { return nil }
        return value << 8 | value >> 8
    }
    
    fileprivate static func load<T>(data: NSData, range: NSRange, as type: T.Type) -> T? {
        guard data.length >= range.location + range.length else { return nil }
        let bytes: [UInt8] = data
            .subdata(with: range)
            .map { $0 }
        return bytes.withUnsafeBytes { p in
            p.loadUnaligned(as: type)
        }
    }
}
