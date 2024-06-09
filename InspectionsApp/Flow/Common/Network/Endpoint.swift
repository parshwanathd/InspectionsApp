//
//  NetworkLayer.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import Foundation

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
        case .register, .login,.submit:
            return .post
        case .start:
            return .get
        }
    }
}
