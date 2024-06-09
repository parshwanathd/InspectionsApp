//
//  TabControlView.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import SwiftUI

struct TabControlView: View {
    @State private var selectedIndex: Int = 0
    @State var isNavigationBarHidden: Bool = true
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            InspectionListView(viewModel: InspectionListViewModel(type: SaveType.draft))
                .navigationBarBackButtonHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                .tabItem {
                    Text(SaveType.draft.rawValue)
                    Image(systemName: "list.clipboard")
                        .renderingMode(.template)
                }.tag(0)
            
            InspectionListView(viewModel: InspectionListViewModel(type: SaveType.completed))
                .navigationBarBackButtonHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                .tabItem {
                    Text(SaveType.completed.rawValue)
                    Image(systemName: "list.clipboard")
                        .renderingMode(.template)
                }.tag(1)
            
        }
        .navigationBarBackButtonHidden(self.isNavigationBarHidden)
        .navigationTitle(selectedIndex == 0 ? SaveType.draft.rawValue : SaveType.completed.rawValue)
        .onAppear {
            self.isNavigationBarHidden = true
        }
        .tint(.pink)
        .onAppear(perform: {
            UITabBar.appearance().unselectedItemTintColor = .systemBrown
            UITabBar.appearance().backgroundColor = .systemGray4.withAlphaComponent(0.4)
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemPink]
        })
    }
}

struct TabControlView_Previews: PreviewProvider {
    static var previews: some View {
        TabControlView()
    }
}
