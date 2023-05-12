//
//  FavoritesBuilder.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import UIKit

protocol FavoritesBuilder {
    func build(delegate: CoordinatorForVCDelegate?) -> UIViewController
}

struct FavoritesBuilderImpl: FavoritesBuilder {
    func build(delegate: CoordinatorForVCDelegate?) -> UIViewController {
        let repoService = GoogleRepoDetailServiceImpl(apiManager: ApiManager())
        let useCase = FavoritesUseCaseImpl(service: repoService, localManager: LocalManager())
        let provider = FavoritesProviderImpl()
        let vm = FavoritesVMImpl(useCase: useCase)
        let vc = FavoritesVC()
        vc.coordinatorDelegate = delegate
        
        vc.inject(vm: vm, provider: provider)

        return vc
    }
}
