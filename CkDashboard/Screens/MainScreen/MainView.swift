//
//  MainView.swift
//  CkDashboard
//
//  Created by Adam Jassak on 23/11/2022.
//

import SwiftUI

// First View of the App
struct MainView: View {
    @StateObject private var vm: MainViewModel
    var body: some View {
        NavigationView {
            LeftPaneView(selectedView: $vm.selectedView)
            switch vm.selectedView {
            case .formulify:
                vm.router.showFormulifyView()
            case .settings:
                /// Empty View for time-being
                EmptyView()
            }
        }
    }

    init() {
        _vm = StateObject(wrappedValue: DI.shared.mainViewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

// Navigation Helper SubView
struct LeftPaneView: View {
    @Binding var selectedView: SelectedView
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(SelectedView.allCases, id: \.self) { item in
                Button(action: {
                    selectedView = item
                }, label: {
                    getLabel(selection: item)
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
                .padding(.horizontal, 10)
            }
            Spacer()
        } .padding(.top, 20)
    }

    func getLabel(selection: SelectedView) -> some View {
        switch selection {
        case .formulify:
            return Label(AppConstant.formulify,
                         systemImage: AppConstant.formulifyIcon)
        case .settings:
            return  Label(AppConstant.settings,
                          systemImage: AppConstant.settingsIcon)
        }
    }
}
