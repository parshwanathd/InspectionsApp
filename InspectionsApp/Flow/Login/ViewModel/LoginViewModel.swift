//
//  LoginViewModel.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import Foundation

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    
    private let networkService: NetworkService
    private var cancellables: Set<AnyCancellable> = []
    @Published var loginStatus: Bool = false
    @Published var isRegister: Bool = true
    var error: String = ""

    init(networkService: NetworkService = NetworkManager()) {
        self.networkService = networkService
    }
    
    func signIn(_ flow: SignUpFLow, _ user: UserModel) {
        let emailError: String? = self.isValidEmail(userName: user.email)
        let passwordError: String? = self.isValidPassword(password: user.password)
        
        if emailError != nil || passwordError != nil {
            self.error = "Please enter" + " " + (emailError ?? "") + (!(passwordError?.isEmpty ?? true) ? " & \(passwordError ?? "")" : "")
            self.loginStatus = false
            return
        }
        signUp(flow, user)
    }
    
    private func signUp(_ flow: SignUpFLow, _ user: UserModel) {
        let response: AnyPublisher<Data, APIError> = networkService.request(flow.endPoint, parameters: user)
        response
            .sink { response in
            switch response {
            case .finished:
                DispatchQueue.main.async {
                    self.error = ""
                    self.loginStatus = true
                }
            case .failure(let error):
                self.error = flow.errorMessage
                self.loginStatus = false
                print(error)
            }
        } receiveValue: { _ in
            
        }.store(in: &cancellables)
    }
    
    deinit{
        cancellables.removeAll()
    }
}

extension LoginViewModel: LoginValidation {}
