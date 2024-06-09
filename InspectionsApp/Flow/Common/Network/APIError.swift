//
//  APIError.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/10/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
    case dataEmpty
}
