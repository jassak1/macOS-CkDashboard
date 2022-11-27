//
//  FormulifyView.swift
//  CkDashboard
//
//  Created by Adam Jassak on 23/11/2022.
//

import SwiftUI

// Formulify Tab View
struct FormulifyView: View {
    @StateObject private var vm: FormulifyViewModel
    var body: some View {
        VStack {
            ForEach(vm.wdc) { item in
                HStack(spacing: 50) {
                    Text("\(item.driver)")
                        .frame(width: 200, alignment: .leading)
                    TextField("", value: $vm.driverPosition[item.driverPosition-1], formatter: NumberFormatter())
                        .frame(width: 50, alignment: .leading)
                    TextField("", value: $vm.driverPoints[item.driverPosition-1], formatter: vm.pointsFormatter)
                        .frame(width: 50, alignment: .leading)
                    Text("\(item.team)")
                        .frame(width: 100, alignment: .leading)
                    TextField("", value: $vm.teamPosition[item.driverPosition-1], formatter: NumberFormatter())
                        .frame(width: 50, alignment: .leading)
                }
                .overlay {
                    Divider().offset(y: 15)
                }
            }
        }
        .font(.system(size: 12))
        .frame(minWidth: 800, minHeight: 500)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    vm.fetchData()
                }, label: {
                    Image(systemName: AppConstant.fetchIcon)
                })
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    vm.updateData()
                }, label: {
                    Image(systemName: AppConstant.modifyIcon)
                })
            }
        }
    }

    init() {
        _vm = StateObject(wrappedValue: DI.shared.formulifyViewModel)
    }
}

struct FormulifyScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormulifyView()
    }
}
