//
//  CoreDataManager.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/11/24.
//

import Foundation
import CoreData


protocol JSONConverter {
    func stringValue<T: Codable>(value: T) throws -> String?
    func decodeValue<T: Decodable>(value: String?, type: T.Type) throws -> T?
}

extension JSONConverter {
    func stringValue<T: Codable>(value: T) throws -> String? {
        let data = try JSONEncoder().encode(value)
        return String(data: data, encoding: String.Encoding.utf8)
    }
    func decodeValue<T: Decodable>(value: String?, type: T.Type) throws -> T? {
        guard let stringValue = value,
              let data = stringValue.data(using: String.Encoding.utf8) else { return nil}
        let model = try JSONDecoder().decode(type, from: data)
        return model
        
    }
}

final class CoreDataManager: JSONConverter {
    
    static let shared: CoreDataManager = CoreDataManager()
    var inspectionModel: [InspectionModel] = []
    private let container: NSPersistentContainer
    private init() {
        container = NSPersistentContainer(name: "InspectionsApp")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        fetchItems()
    }
    
    func fetchItems() {
        let request = NSFetchRequest<InspectionModel>(entityName: "InspectionModel")
        
        do {
            inspectionModel = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching \(error)")
        }
    }
    
    func fetchItems(id: Int) throws -> InspectionModel? {
        return inspectionModel.first(where: {$0.id == Int16(id)})
    }
    
    func fetchItems(type: SaveType) -> [Inspection] {
        do {
            return try inspectionModel.filter({$0.status == type.rawValue}).compactMap({try self.decodeValue(value: $0.data, type: Inspection.self)})
        } catch let error {
            print("Error fetching \(error)")
            return []
        }
    }
    
    func saveItems(data: Inspection, status: SaveType) {
        do {
            guard let item: InspectionModel = try fetchItems(id: data.id) else {
                add(data: data, status: status)
                return
            }
            item.data = try self.stringValue(value: data)
            item.status = status.rawValue
            try container.viewContext.save()
            fetchItems()
        } catch (let error) {
            print(error)
        }
    }
    
    private func add(data: Inspection, status: SaveType) {
        do {
            let dataModel = InspectionModel(context: container.viewContext)
            dataModel.id = Int16(data.id)
            dataModel.data = try self.stringValue(value: data)
            dataModel.status = status.rawValue
            try container.viewContext.save()
            fetchItems()
        } catch (let error) {
            print(error)
        }
    }
}
