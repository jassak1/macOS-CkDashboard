//
//  DI.swift
//  CkDashboard
//
//  Created by Adam Jassak on 23/11/2022.
//

import Foundation

/// Dependency Injection
class DI {
    static let shared = DI()

    // MARK: Private properties (Mostly service instances)
    private let router:Router
    private let ckProvider: CkProvider
    private let genuineRepo: GenuineRepo

    // MARK: Public properties
    public let mainViewModel: MainViewModel
    public let formulifyViewModel: FormulifyViewModel


    /// Initialiser
    init() {
        router = Router()
        ckProvider = CkProvider()
        genuineRepo = GenuineRepo(ckProvider: ckProvider)

        mainViewModel = MainViewModel(router: router)
        formulifyViewModel = FormulifyViewModel(genuineRepo: genuineRepo)
    }
}
