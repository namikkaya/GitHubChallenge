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
}

struct HomeUseCaseImpl: HomeUseCase {
    private let listService: GoogleRepoListService
    init(service: GoogleRepoListService){
        self.listService = service
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
}
