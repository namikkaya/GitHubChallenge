//
//  FavoritesCoordinator.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import Foundation

import UIKit

final class FavoritesTabCoordinator: NSObject, SubCoordinator {
    var childCoordinators: [Coordinator] = []
    
    var coordinatorStateClosure: ((CoordinatorEventType) -> ())?
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("XYZ: \(self.className) deinit")
    }
    
    func start() {
        let favoritesVC = FavoritesBuilderImpl().build(delegate: self)
        navigationController.viewControllers = [favoritesVC]
    }
    
    func reset(completion: (() -> ())?) {
        let group = DispatchGroup()
        self.childCoordinators.reversed().forEach { coordinatorItem in
            group.enter()
            coordinatorItem.reset {
                if let presentedController = self.navigationController.presentedViewController {
                    group.enter()
                    presentedController.dismiss(animated: false) { [weak self] in
                        self?.navigationController.popToRootViewController(animated: false)
                        group.leave()
                    }
                }
                group.leave()
            }
            removeChild(coordinator: coordinatorItem)
        }
        
        group.notify(queue: .main) {
            print("XYZ: \(self.className) Finish reset")
            completion?()
        }
    }
}

extension FavoritesTabCoordinator: CoordinatorForVCDelegate {
    func coordinatorCommand(type: FlowType) {
        
    }
}
