//
//  CkProvider.swift
//  CkDashboard
//
//  Created by Adam Jassak on 23/11/2022.
//

import Foundation
import CloudKit

// CloudKit Service
class CkProvider {
    /// Property representing CloudKit database (Public)
    var database: CKDatabase {
        let db = CKContainer(identifier: AppConstant.ckIdentifier)
        return db.publicCloudDatabase
    }

    /// Method responsible for querying specific RecordType from CloudKit
    ///
    /// - Parameters:
    ///     - record: Specific `CKRecord` to be queried
    /// - Returns: Array of `CKRecord` items
    func queryDatabase(for record: CKRecord) async throws -> [CKRecord] {
        let predicate = NSPredicate(value: true)
        let sortDescriptor = NSSortDescriptor(key: AppConstant.ckSortKey, ascending: true)
        let query = CKQuery(recordType: record.recordType, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]

        let allRecords = try await database.records(matching: query).matchResults.map { result -> CKRecord in
            return try result.1.get()
        }
        return allRecords
    }
}
