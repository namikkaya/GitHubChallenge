//
//  GoogleRepoListService.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import Foundation

protocol GoogleRepoListService {
    func fetchGoogleRepoList(req: GoogleRepoRequestEntity, completion: @escaping (Result<[GoogleRepoListEntity], KError>) -> ())
    var totalPage: Int? { get }
}

struct GoogleRepoListServiceImpl: GoogleRepoListService {
    let api: ApiManager
    
    init(apiManager: ApiManager) {
        self.api = apiManager
    }
    
    var totalPage: Int? {
        return api.totalPage
    }
    
    func fetchGoogleRepoList(req: GoogleRepoRequestEntity, completion: @escaping (Result<[GoogleRepoListEntity], KError>) -> ()){
        api.fetchData(httpMethod: .get, endPoint: .repoList, parameter: req, outPutEntity: [GoogleRepoListEntity].self, completion: completion)
    }
}
