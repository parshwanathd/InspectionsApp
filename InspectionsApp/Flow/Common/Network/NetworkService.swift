//
//  NetworkService.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/10/24.
//

import Foundation
import Combine

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
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
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.requestFailed("An unknown error occurred.")
                }
            }
            .eraseToAnyPublisher()
    }
}
