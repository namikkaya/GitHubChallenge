//
//  HomeUseCase.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import Foundation

protocol HomeUseCase {
    func fetchGoogleRepoList(pageNumber:Int?, completion: @escaping (Result<[GoogleRepoListEntity], KError>) -> ())
    var perPage: Int { get }
    var totalPage: Int? { get }
    func localSave(data: GoogleRepoListEntity?, completion: @escaping (Result<Bool, KError>) -> ())
    func fetchAll(completion: @escaping (Result<[LocalFavoriteEntity], KError>) -> ())
    func deleteRecords(id: Int, completion: @escaping (Result<Bool, KError>) -> ())
}

struct HomeUseCaseImpl: HomeUseCase {
    private let listService: GoogleRepoListService
    private let local: LocalManager
    init(service: GoogleRepoListService, localManager: LocalManager){
        self.listService = service
        self.local = localManager
    }
    
    func fetchGoogleRepoList(pageNumber:Int?, completion: @escaping (Result<[GoogleRepoListEntity], KError>) -> ()) {
        let req = GoogleRepoRequestEntity(page: pageNumber, perPage: perPage)
        listService.fetchGoogleRepoList(req: req, completion: completion)
    }
    
    var perPage:Int {
        return 15
    }
    
    var totalPage: Int? {
        return listService.totalPage
    }
    
    func localSave(data: GoogleRepoListEntity?, completion: @escaping (Result<Bool, KError>) -> ()) {
        if let id = data?.id, let name = data?.name, let logo = data?.owner?.avatarURL {
            local.save(id: id, name: name, logoUrl: logo, completion: completion)
        }
    }
    
    func deleteRecords(id: Int, completion: @escaping (Result<Bool, KError>) -> ()) {
        local.deleteRecords(id: id, completion: completion)
    }
    
    func fetchAll(completion: @escaping (Result<[LocalFavoriteEntity], KError>) -> ()) {
        local.fetch(completion: completion)
    }
}
