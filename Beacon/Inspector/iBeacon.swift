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
    
    func mData() -> Data {
        if let manufacturerData {
            return manufacturerData
        }
        var manufacturerData = Data(repeating: 0x00, count: 25)
        let header: [UInt8] = [0x00, 0x00, 0x02, 0x15]
        manufacturerData[0..<4] = header.withUnsafeBytes { header_t in
            NSData(bytes: header_t.baseAddress, length: 4) as Data
        }
        
        var uuid = beaconID
        manufacturerData[4..<20] = withUnsafeBytes(of: &uuid) { uuid_t in
            NSData(bytes: uuid_t.baseAddress, length: 16) as Data
        }
        
        var major = (self.major << 8) | (self.major >> 8)
        manufacturerData[20..<22] = withUnsafeBytes(of: &major) { major_t in
            NSData(bytes: major_t.baseAddress, length: 2) as Data
        }
        
        var minor = (self.minor << 8) | (self.minor >> 8)
        manufacturerData[22..<24] = withUnsafeBytes(of: &minor) { minor_t in
            NSData(bytes: minor_t.baseAddress, length: 2) as Data
        }
        
        return manufacturerData
    }
    
    static var example: iBeacon {
        iBeacon(
            beaconID: UUID(uuidString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!,
            major: 10090,
            minor: 57622
        )
    }
    
    static var random: iBeacon {
        iBeacon(
            beaconID: UUID(),
            major: UInt16.random(in: 0 ..< UInt16.max),
            minor: UInt16.random(in: 0 ..< UInt16.max)
        )
    }
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
            p.load(as: type)
        }
    }
}
