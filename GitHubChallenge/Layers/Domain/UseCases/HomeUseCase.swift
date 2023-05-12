//
//  HomeUseCase.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import Foundation

protocol HomeUseCase {
    func fetchGoogleRepoList(pageNumber:Int?,filterSort: GoogleRepoRequestEntity.SortType?, filterType: GoogleRepoRequestEntity.ReqType?, completion: @escaping (Result<[GoogleRepoListEntity], KError>) -> ())
    var perPage: Int { get }
    var totalPage: Int? { get }
    var favoritesData: [LocalFavoriteEntity] { get set }
    func localSave(data: GoogleRepoListEntity?, completion: @escaping (Result<Bool, KError>) -> ())
    func fetchAll(completion: @escaping (Result<[LocalFavoriteEntity], KError>) -> ())
    func deleteRecord(id: Int, completion: @escaping (Result<Bool, KError>) -> ())
    func checkDataExists(id: Int, completion: @escaping (Result<Bool, KError>) -> ())
}

struct HomeUseCaseImpl: HomeUseCase {
    private let listService: GoogleRepoListService
    private let local: LocalManager
    init(service: GoogleRepoListService, localManager: LocalManager){
        self.listService = service
        self.local = localManager
    }
    
    var favoritesData: [LocalFavoriteEntity] = []
    
    func fetchGoogleRepoList(pageNumber:Int?, filterSort: GoogleRepoRequestEntity.SortType? = .created, filterType: GoogleRepoRequestEntity.ReqType? = .all, completion: @escaping (Result<[GoogleRepoListEntity], KError>) -> ()) {
        let req = GoogleRepoRequestEntity(page: pageNumber, perPage: perPage, sort: filterSort ?? .created, type: filterType ?? .all)
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
