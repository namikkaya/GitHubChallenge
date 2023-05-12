//  FavoritesUseCase.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 12.05.2023.
//  

protocol FavoritesUseCase {
    func fetchLocalRepoList(completion: @escaping (Result<[LocalFavoriteEntity], KError>) -> ())
}

struct FavoritesUseCaseImpl: FavoritesUseCase {
    private let listService: GoogleRepoDetailService
    private let local: LocalManager
    init(service: GoogleRepoDetailService, localManager: LocalManager){
        self.listService = service
        self.local = localManager
    }
    
    func fetchLocalRepoList(completion: @escaping (Result<[LocalFavoriteEntity], KError>) -> ()) {
        local.fetch(completion: completion)
    }
}
