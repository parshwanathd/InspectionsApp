//
//  InspectionListView.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/9/24.
//

import SwiftUI

struct InspectionListView: View {
    //TODO: Pass item list here
    @StateObject var viewModel: InspectionListViewModel
    
    var body: some View {
        VStack() {
            if !viewModel.items.isEmpty {
                listItem
            } else {
                Text("No \(viewModel.type.rawValue) Item")
            }
            inspectionStart
        }.onAppear {
            viewModel.updateItems()
        }
    }
    
    @ViewBuilder
    var listItem: some View {
        List(viewModel.items) { item in
            NavigationLink {
                InspectionView(viewModel: InspectionViewModel(data: item))
            } label: {
                Text(item.inspectionType.name)
                    .font(.title3)
                    .fontWeight(.regular)
            }
        }
    }
    
    @ViewBuilder
    var inspectionStart: some View {
        if viewModel.type == .draft {
            PrimaryButtonView(title: "Start New Inspection", verticalPadding: 5) {
                viewModel.startInspection()
            }.padding(.vertical, 16)
        }
    }
}

/*struct InspectionListView_Previews: PreviewProvider {
    static var previews: some View {
        InspectionListView()
    }
}*/
