//
//  DetailsBuilder.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 12.05.2023.
//

import UIKit

protocol DetailsBuilder {
    func build(delegate: CoordinatorForVCDelegate?, data: GoogleRepoListEntity?) -> UIViewController
}

struct DetailsBuilderImpl: DetailsBuilder {
    func build(delegate: CoordinatorForVCDelegate?, data: GoogleRepoListEntity?) -> UIViewController {
        let local = LocalManager()
        let useCase = DetailUseCaseImpl(localManager: local)
        let vm = DetailVMImpl(useCase: useCase, data: data)
        let provider = DetailUIProviderImpl()
        let vc = DetailsVC()
        vc.coordinatorDelegate = delegate
        vc.inject(vm: vm, provider: provider)
        return vc
    }
}
