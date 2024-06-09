//
//  LoginDataModel.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import Foundation

protocol LoginValidation {
    func isValidEmail(userName: String) -> String?
    func isValidPassword(password: String) -> String?
}
extension LoginValidation {
    
    func isValidEmail(userName: String) -> String? {
        guard !userName.isEmpty else { return "Email id"}
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: userName) ? nil : "valid Email Id"
    }
    
    func isValidPassword(password: String) -> String? {
        password.isEmpty ? "password" : nil
    }
}

// MARK: - Welcome
struct UserModel: Codable {
    let email, password: String
}
