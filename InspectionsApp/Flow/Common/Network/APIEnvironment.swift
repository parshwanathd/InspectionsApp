//
//  APIEnvironment.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/10/24.
//

import Foundation

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
