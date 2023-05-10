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
        let vc = FavoritesVC()
        vc.coordinatorDelegate = delegate

        return vc
    }
}
