//
//  LocalManager.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import UIKit
import CoreData

final class LocalManager {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    func save(id: Int, name: String, logoUrl: String, completion: @escaping (Result<Bool, KError>) -> ()) {
        let context = appDelegate.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "GitHubEntity", in: context) else { return }
        let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
        
        newValue.setValue(id, forKey: "id")
        newValue.setValue(name, forKey: "name")
        newValue.setValue(logoUrl, forKey: "logoURL")
        
        do {
            try context.save()
            completion(.success(true))
        }catch {
            completion(.failure(KError(errorCode: .localSaveDataError)))
        }
    }
    
    func fetch(completion: @escaping (Result<[LocalFavoriteEntity], KError>) -> ()) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<GitHubEntity>(entityName: "GitHubEntity")
        do {
            let results = try context.fetch(fetchRequest)
            var favorites: [LocalFavoriteEntity] = []
            for result in results {
                let favorite = LocalFavoriteEntity(id: Int(result.id), name: result.name, logoURL: result.logoURL)
                favorites.append(favorite)
            }
            completion(.success(favorites))
        }catch {
            completion(.failure(KError(errorCode: .localFetchDataError)))
        }
    }
    
    func deleteRecords(id: Int, completion: @escaping (Result<Bool, KError>) -> ()) {
        let context = appDelegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GitHubEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(KError(errorCode: .general)))
        }
    }
    
}
