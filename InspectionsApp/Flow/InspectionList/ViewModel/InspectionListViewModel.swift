//
//  InspectionListViewModel.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/10/24.
//

import Foundation
import Combine

enum SaveType: String {
    case draft = "Draft"
    case completed = "Completed"
    
}

class InspectionListViewModel: ObservableObject {
    @Published var items: [Inspection] = []
    private let networkService: NetworkService
    private var cancellables: Set<AnyCancellable> = []
    var type: SaveType
    
    init(type: SaveType,
        networkService: NetworkService = NetworkManager()) {
        self.items = CoreDataManager.shared.fetchItems(type: type)
        self.networkService = networkService
        self.type = type
    }
    
    func updateItems() {
        CoreDataManager.shared.fetchItems()
        self.items = CoreDataManager.shared.fetchItems(type: type)
    }
    
    class func mapItem(data: [InspectionModel]) -> [Inspection?] {
        return data.map({Self.converItem(data: $0.data ?? "")})
    }
    class func converItem(data: String) -> Inspection? {
        
        let jsonData = data.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        do {
            let inspection = try jsonDecoder.decode(Inspection.self, from: jsonData)
            return inspection
        } catch(let error) {
            print("converItem failed \(error)")
            return nil
        }
    }
    
    func startInspection() {
        let response: AnyPublisher<InspectionDataModel, APIError> = networkService.request(.start, parameters: nil)
        response.sink { response in
                switch response {
                case .finished:
                    print("Finised start Inspection ")
                case .failure(let error):
                        print(error)
                }
            } receiveValue: { inspection in
                DispatchQueue.main.async {
                    self.items.append(inspection.inspection)
                }
            }.store(in: &cancellables)

    }
    
    deinit {
        cancellables.removeAll()
    }
}
