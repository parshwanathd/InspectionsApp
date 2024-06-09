//
//  LoginView.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import SwiftUI

struct LoginView: View {
    @State var userName = ""
    @State var password = ""
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    @State private var isShowingDetailView = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Loin")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding(.bottom, 24)
                VStack(alignment: .leading, spacing: 16) {
                    TextFieldView(data: $userName, title: "Email")
                    TextFieldView(data: $password, title: "Password")
                }.padding(16)
                NavigationLink(destination: TabControlView(), isActive: $isShowingDetailView) {
                    PrimaryButtonView(title: "Login") {
                        viewModel.signIn()
                    }
                }
            }.onReceive(viewModel.$loginStatus, perform: { newValue in
                isShowingDetailView = newValue
            })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct PrimaryButtonView: View {
    var title: String
    var action: (() -> Void)
    var horizontalPadding: Double
    var verticalPadding: Double
    
    init(title: String,
         horizontalPadding: Double = 30,
         verticalPadding: Double = 8,
         action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .fontWeight(.heavy)
                .font(.title3)
                .frame(width: .infinity, height: horizontalPadding)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .foregroundColor(.white)
                .background {
                    Color(.red)
                        .cornerRadius(verticalPadding)
                }
        }

    }
}
