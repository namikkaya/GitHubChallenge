//
//  HomeBuilder.swift
//  GitHubChallenge
//
//  Created by namik kaya on 9.05.2023.
//

import UIKit

protocol HomeBuilder {
    func build(delegate: CoordinatorForVCDelegate?) -> UIViewController
}

struct HomeBuilderImpl: HomeBuilder {
    func build(delegate: CoordinatorForVCDelegate?) -> UIViewController {
        let api = ApiManager()
        let listService = GoogleRepoListServiceImpl(apiManager: api)
        let useCase = HomeUseCaseImpl(service: listService)
        let vm = HomeVMImpl(useCase: useCase)
        let provider = HomeListProviderImpl()
        let vc = HomeVC()
        vc.coordinatorDelegate = delegate
        vc.inject(vm: vm, provider: provider)
        return vc
    }
}
