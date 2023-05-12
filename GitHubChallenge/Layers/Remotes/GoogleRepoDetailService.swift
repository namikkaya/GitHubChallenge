//
//  GoogleRepoDetailService.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 12.05.2023.
//

import Foundation

protocol GoogleRepoDetailService {
    func fetchGoogleDetail(name: String, completion: @escaping (Result<GoogleRepoListEntity, KError>) -> ())
}

struct GoogleRepoDetailServiceImpl: GoogleRepoDetailService {
    
    let api: ApiManager
    
    init(apiManager: ApiManager) {
        self.api = apiManager
    }
    
    func fetchGoogleRepoList(req: GoogleRepoRequestEntity, completion: @escaping (Result<[GoogleRepoListEntity], KError>) -> ()){
        api.fetchData(httpMethod: .get, endPoint: .repoList, parameter: req, outPutEntity: [GoogleRepoListEntity].self, completion: completion)
    }
    
    func fetchGoogleDetail(name: String, completion: @escaping (Result<GoogleRepoListEntity, KError>) -> ()) {
        let path = ApiManager.EndPoint.repoDetail.getPath(param: name)
        api.fetchData(httpMethod: .get, endPoint: path, outPutEntity: GoogleRepoListEntity.self, completion: completion)
    }
}
