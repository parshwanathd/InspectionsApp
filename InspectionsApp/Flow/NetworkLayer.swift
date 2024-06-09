//
//  NetworkLayer.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
    case dataEmpty
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Endpoint {
    case register
    case login
    case start
    case submit

    var path: String {
        switch self {
        case .register:
            return "/api/register"
        case .login:
            return "/api/login"
        case .start:
            return "/api/inspections/start"
        case .submit:
            return "/api/inspections/submit"
        }
    }

    var httpMethod: HttpMethod {
        switch self {
        case .register, .login, .submit:
            return .post
        case .start:
            return .get
        }
    }
}

enum APIEnvironment {
    case development
    case staging
    case production

    var baseURL: String {
        switch self {
        case .development, .staging, .production:
            return "http://127.0.0.1:5001"
        }
    }
}

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint, parameters: Encodable?) -> AnyPublisher<T, APIError>
    func request(_ endpoint: Endpoint, parameters: Encodable?) -> AnyPublisher<Data, APIError>
}

class NetworkManager: NetworkService {
    private let baseURL: String
    
    init(environment: APIEnvironment = NetworkManager.defaultEnvironment()) {
        self.baseURL = environment.baseURL
    }
    
    static func defaultEnvironment() -> APIEnvironment {
        return .development
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, parameters: Encodable? = nil) -> AnyPublisher<T, APIError> {
        request(endpoint, parameters: parameters)
            .decode(type: T.self, decoder: JSONDecoder())
            .tryMap { (dataModel) -> T in
                return dataModel
            }
            .mapError { error -> APIError in
                if error is DecodingError {
                    return APIError.decodingFailed
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.requestFailed("An unknown error occurred.")
                }
            }
            .eraseToAnyPublisher()
    }
    
    func request(_ endpoint: Endpoint, parameters: Encodable? = nil) -> AnyPublisher<Data, APIError> {
        guard let url = URL(string: baseURL + endpoint.path) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        
        if let parameters = parameters {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let jsonData = try JSONEncoder().encode(parameters)
                urlRequest.httpBody = jsonData
            } catch {
                return Fail(error: APIError.requestFailed("Encoding parameters failed.")).eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse,
                   (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    throw APIError.requestFailed("Request failed with status code: \(statusCode)")
                }
            }.tryMap { data in
                return data
            }
            .mapError { error -> APIError in
                if error is DecodingError {
                    return APIError.decodingFailed
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.requestFailed("An unknown error occurred.")
                }
            }
            .eraseToAnyPublisher()
    }
}
