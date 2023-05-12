//
//  DetailUseCase.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 12.05.2023.
//

import Foundation

protocol DetailUseCase {
    func localSave(data: GoogleRepoListEntity?, completion: @escaping (Result<Bool, KError>) -> ())
    func fetchAll(completion: @escaping (Result<[LocalFavoriteEntity], KError>) -> ())
    func deleteRecord(id: Int, completion: @escaping (Result<Bool, KError>) -> ())
    func checkDataExists(id: Int, completion: @escaping (Result<Bool, KError>) -> ())
}

struct DetailUseCaseImpl: DetailUseCase {
    private let local: LocalManager
    init(localManager: LocalManager){
        self.local = localManager
    }
    
    func localSave(data: GoogleRepoListEntity?, completion: @escaping (Result<Bool, KError>) -> ()) {
        if let id = data?.id, let name = data?.name, let logo = data?.owner?.avatarURL {
            local.save(id: id, name: name, logoUrl: logo, completion: completion)
        }
    }
    
    func deleteRecord(id: Int, completion: @escaping (Result<Bool, KError>) -> ()) {
        local.deleteRecord(id: id, completion: completion)
    }
    
    func fetchAll(completion: @escaping (Result<[LocalFavoriteEntity], KError>) -> ()) {
        local.fetch(completion: completion)
    }
    
    func checkDataExists(id: Int, completion: @escaping (Result<Bool, KError>) -> ()) {
        local.checkDataExists(id: id, completion: completion)
    }
}
