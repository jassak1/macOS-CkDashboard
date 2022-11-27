//
//  GenuineRepo.swift
//  CkDashboard
//
//  Created by Adam Jassak on 24/11/2022.
//

import Foundation
import CloudKit

// Genuine Repository - fetched WDC records + updated WDC records
class GenuineRepo {
    let ckProvider: CkProvider

    /// Method responsible for fetching data from CloudKit's WDC RT
    /// and transforming those to array of WDC type
    ///
    /// - Returns: Array of `WDC` items
    func fetchWdcRecords() async throws -> [WDC] {
        let ckRecordType = CKRecord(recordType: AppConstant.recordType)

        let records = try await ckProvider.queryDatabase(for: ckRecordType)
        return records.map { record -> WDC in
            let driver = record[AppConstant.driverField] as? String ?? String()
            let driverPosition = record[AppConstant.driverPositionField] as? Int ?? Int()
            let points = record[AppConstant.pointsField] as? Float ?? Float()
            let team = record[AppConstant.teamField] as? String ?? String()
            let teamPosition = record[AppConstant.teamPositionField] as? Int ?? Int()
            return WDC(driver: driver, driverPosition: driverPosition, points: points,
                       team: team,
                       teamPosition: teamPosition)
        }
    }

    /// Method responsible for modifying WDC RecordType items on CloudKit
    ///
    /// - Parameters:
    ///     - records: Array of modified `WDC` objects
    func updateDatabase(with records: [WDC]) async throws {
        let ckRecordType = CKRecord(recordType: AppConstant.recordType)
        let fetchedRecords = try await ckProvider.queryDatabase(for: ckRecordType)

        let modifiedRecords = fetchedRecords.map { item in
            let subRecord = item
            subRecord[AppConstant.driverPositionField] =
                    records.first(where: { $0.driver == item[AppConstant.driverField] })?.driverPosition
            subRecord[AppConstant.pointsField] =
                    records.first(where: { $0.driver == item[AppConstant.driverField] })?.points
            subRecord[AppConstant.teamPositionField] =
                    records.first(where: { $0.driver == item[AppConstant.driverField] })?.teamPosition
            return subRecord
        }

        _ = try await ckProvider.database.modifyRecords(saving: modifiedRecords, deleting: [])
    }

    /// Initialiser
    init(ckProvider: CkProvider) {
        self.ckProvider = ckProvider
    }
}

// MARK: WDC Model
/// WDC (Driver's championship) type, containing standings properties
struct WDC: Codable, Identifiable {
    var id = UUID()
    var driver: String
    var driverPosition: Int
    var points: Float
    var team: String
    var teamPosition: Int
}
