//
//  MainViewModel.swift
//  CkDashboard
//
//  Created by Adam Jassak on 23/11/2022.
//

import SwiftUI

// Enum holding navigation View types
enum SelectedView: CaseIterable {
    case formulify
    case settings
}

// ViewModel for `MainView()`
class MainViewModel: ObservableObject {
    let router: Router
    @Published var selectedView: SelectedView = .formulify

    /// Initialiser
    init(router: Router) {
        self.router = router
    }
}
