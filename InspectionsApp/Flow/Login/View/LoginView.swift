//
//  LoginView.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import SwiftUI

enum SignUpFLow {
    case login
    case register
    
    var title: String {
        switch self {
        case .login:
            return "Sign In"
        case .register:
            return "Register"
        }
    }
    
    var toggleTitle: String {
        switch self {
        case .login:
            return "Sign In with credentials"
        case .register:
            return "Register for Sign In "
        }
    }
    
    var endPoint: Endpoint {
        switch self {
        case .login:
            return .login
        case .register:
            return .register
        }
    }
    
    var errorMessage: String {
        switch self {
        case .login:
            return "Sign In failed"
        case .register:
            return "Unable to register user"
        }
    }
}

struct LoginView: View {
    @State var userName = ""
    @State var password = ""
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    @State private var isShowingDetailView = false
    @State private var isSignIN: Bool = true
    @State private var flow: SignUpFLow = .register
    var body: some View {
        NavigationView {
            VStack {
                Text(flow.title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .padding(.bottom, 24)
                VStack(alignment: .leading, spacing: 16) {
                    TextFieldView(data: $userName, title: "Email")
                    TextFieldView(data: $password, title: "Password")
                    if !isShowingDetailView && !viewModel.error.isEmpty {
                        Text(viewModel.error)
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    Toggle(isOn: $isSignIN) {
                        Text(flow.toggleTitle)
                            .font(.headline)
                    }
                }.padding(16)
                NavigationLink(destination: TabControlView(), isActive: $isShowingDetailView) {
                    PrimaryButtonView(title: flow.title) {
                        viewModel.signIn(flow, UserModel(email: userName, password: password))
                    }
                }
            }.onReceive(viewModel.$loginStatus, perform: { newValue in
                isShowingDetailView = newValue
            })
            .onChange(of: isSignIN) { newValue in
                flow = newValue == true ? .login : .register
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
