//
//  InspectionViewModel.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/10/24.
//

import Foundation
import Combine

class InspectionViewModel: ObservableObject {
    var data: [Category]
    var inspection: Inspection
    private var cancelable: Set<AnyCancellable> = []
    private var networkService: NetworkService
    
    @Published var currentIndex = 0
    @Published var hidePreviousAction = false
    @Published var hideNextAction = false
    @Published var submitted: String?
    
    var saveType: SaveType {
        
        self.inspection.survey.categories = self.data
        for (_, element) in self.inspection.survey.categories.enumerated() {
            for (_, question) in element.questions.enumerated() {
                if question.selectedAnswerChoiceID == nil || question.selectedAnswerChoiceID?.isEmpty ?? true || question.selectedAnswerChoiceID == "0" {
                    return .draft
                }
            }
        }
        return SaveType.completed
    }
    
    init(data: Inspection,
         networkService: NetworkService = NetworkManager()) {
        self.inspection = data
        self.data = data.survey.categories
        self.networkService = networkService
    }
    
    func updateQuestion(newValue: Int,selectedCategorie: Int ) {
        self.data = data.map { categorieValue in
            var categorie = categorieValue
            categorie.questions = categorieValue.questions.map { questionValue in
                var questionNewValue = questionValue
                if let id2 = selectedQuestion(selectedCategorie: selectedCategorie)?.name,
                   questionValue.name == id2 {
                    questionNewValue.selectedAnswerChoiceID = "\(newValue)"
                }
                return questionNewValue
            }
            return categorie
        }
    }
    
    func startQuestion(selectedCategorie: Int) {
        currentIndex = 0
        disableAction(questions: data.first(where: {$0.id == selectedCategorie})?.questions ?? [])
    }
    
    func nextQuestion(selectedCategorie: Int) {
        if data.first(where: {$0.id == selectedCategorie})?.questions.count ?? 0 > (currentIndex + 1) {
            currentIndex += 1
        }
        
        self.disableAction(questions: data.first(where: {$0.id == selectedCategorie})?.questions ?? [])
    }
    
    
    func preQuestion(selectedCategorie: Int) {
        if (currentIndex - 1) > -1 {
            currentIndex -= 1
        }
        self.disableAction(questions: data.first(where: {$0.id == selectedCategorie})?.questions ?? [])
    }
    
    func disableAction(questions: [Question]) {
        if currentIndex == 0 {
            hidePreviousAction = true
            hideNextAction = false
        } else if questions.count == currentIndex + 1 {
            hidePreviousAction = false
            hideNextAction = true
        } else {
            hidePreviousAction = false
            hideNextAction = false
        }
    }
    
    func selectedQuestion(selectedCategorie: Int) -> Question? {
        if data.first(where: {$0.id == selectedCategorie})?.questions.count ?? 0 > currentIndex {
            return data.first(where: {$0.id == selectedCategorie})?.questions[currentIndex]
        }
        return nil
    }
    
    func selectedAnswer(selectedCategorie: Int) -> Int {
        Int(selectedQuestion(selectedCategorie: selectedCategorie)?.selectedAnswerChoiceID ?? "0") ?? 0
    }
    
    func save() {
        self.inspection.survey.categories = self.data
        CoreDataManager.shared.saveItems(data: inspection, status: saveType)
        if saveType == .completed {
            submitDetails()
        }
    }
    
    func submitDetails() {
        let response: AnyPublisher<Data, APIError> = networkService.request(.submit, parameters: InspectionDataModel(inspection: self.inspection))
        response
            .sink { response in
                DispatchQueue.main.async {
                    switch response {
                    case .finished:
                        self.submitted = "Submitted Successfully"
                    case .failure(let error):
                        print(error)
                        self.submitted = "Something went wrong"
                    }
                }
            } receiveValue: { _ in
                
            }.store(in: &cancelable)
    }
}
