//
//  LoginViewModel.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import Foundation

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    private let networkService: NetworkService
    private var cancellables: Set<AnyCancellable> = []
    @Published var loginStatus: Bool = false
    
    init(networkService: NetworkService = NetworkManager()) {
        self.networkService = networkService
    }
    func signIn() {
        let response: AnyPublisher<Data, APIError> = networkService.request(.login, parameters: UserModel(email: "johnd@email.com", password: "dogsname2015"))
        response
            .sink { response in
            switch response {
            case .finished:
                DispatchQueue.main.async {
                    self.loginStatus = true
                }
            case .failure(let error):
                    print(error)
            }
        } receiveValue: { _ in
            
        }.store(in: &cancellables)

    }
}

struct ResponseModel: Decodable {
}
