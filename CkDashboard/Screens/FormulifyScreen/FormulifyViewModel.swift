//
//  FormulifyViewModel.swift
//  CkDashboard
//
//  Created by Adam Jassak on 23/11/2022.
//

import SwiftUI

// ViewModel Class for the `FormulifyView()`
class FormulifyViewModel: ObservableObject {
    /// Private instance of `GenuineRepo`
    private let genuineRepo: GenuineRepo

    /// Specific NumberFormatter used within TextField (Decimal formatter with dot decimal separator)
    var pointsFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        return formatter
    }

    /// Combine properties related to standings table
    @Published var wdc = [WDC]()
    @Published var driverPosition = [Int]()
    @Published var driverPoints = [Float]()
    @Published var teamPosition = [Int]()

    /// Method responsible for fetching latest data from CloudKit (WDC Record type)
    func fetchData() {
        Task { @MainActor in
            do {
                try wdc = await genuineRepo.fetchWdcRecords()
                driverPosition = wdc.map { ($0.driverPosition) }
                driverPoints = wdc.map { ($0.points) }
                teamPosition = wdc.map { ($0.teamPosition) }
            } catch {
                /// Failed fetching WDC Records from CloudKit
            }
        }
    }

    /// Method responsible for trigerring data update to CloudKit
    func updateData() {
        let updatedWdc = wdc.map {
            WDC(driver: $0.driver,
                driverPosition: driverPosition[$0.driverPosition-1],
                points: driverPoints[$0.driverPosition-1],
                team: $0.team,
                teamPosition: teamPosition[$0.driverPosition-1])
        }
        Task { @MainActor in
            do {
                try await genuineRepo.updateDatabase(with: updatedWdc)
            } catch {
                /// Failed updating WDC Records on CloudKit
            }
        }
    }

    /// Initialiser
    init(genuineRepo: GenuineRepo) {
        self.genuineRepo = genuineRepo
        fetchData()
    }
}
