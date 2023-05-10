//
//  SplashBuilder.swift
//  GitHubChallenge
//
//  Created by namik kaya on 9.05.2023.
//

import UIKit

protocol SplashBuilder {
    func build(delegate: CoordinatorForVCDelegate?) -> UIViewController
}

struct SplashBuilderImpl: SplashBuilder {
    func build(delegate: CoordinatorForVCDelegate?) -> UIViewController {
        let vc = SplashVC()
        let vm = SplashVMImpl()
        let provider = SplashUIProviderImpl()
        vc.coordinatorDelegate = delegate
        vc.inject(vm: vm, provider: provider)
        return vc
    }
}
