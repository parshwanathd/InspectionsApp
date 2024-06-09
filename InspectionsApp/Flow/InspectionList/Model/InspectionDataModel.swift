//
//  InspectionData.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import Foundation

struct InspectionDataModel: Codable {
    let inspection: Inspection
}

// MARK: - Inspection
struct Inspection: Codable, Identifiable {
    let area: Area
    let id: Int
    let inspectionType: InspectionType
    var survey: Survey
}

// MARK: - Area
struct Area: Codable {
    let id: Int
    let name: String
}

// MARK: - InspectionType
struct InspectionType: Codable {
    let access: String
    let id: Int
    let name: String
}

// MARK: - Survey
struct Survey: Codable {
    var categories: [Category]
    let id: Int
}

// MARK: - Category
struct Category: Codable, Identifiable {
    let id: Int
    let name: String
    var questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let answerChoices: [AnswerChoice]
    var id: Int
    let name: String
    var selectedAnswerChoiceID: String?

    enum CodingKeys: String, CodingKey {
        case answerChoices, id, name
        case selectedAnswerChoiceID = "selectedAnswerChoiceId"
    }
}

// MARK: - AnswerChoice
struct AnswerChoice: Codable, Identifiable {
    let id: Int
    let name: String
    let score: Double
}
