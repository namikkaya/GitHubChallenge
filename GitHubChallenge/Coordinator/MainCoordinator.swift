//
//  MainCoordinator.swift
//  GitHubChallenge
//
//  Created by namik kaya on 9.05.2023.
//

import UIKit

final class MainCoordinator: NSObject, Coordinator {
    
    var coordinatorStateClosure: ((CoordinatorEventType) -> ())?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabbarController: MainTabbarVC?
    
    private var homeNavigationController: UINavigationController?
    private var favoritesNavigationController: UINavigationController?
    private var homeTabCoordinator: SubCoordinator?
    private var favoritesTabCoordinator: SubCoordinator?
    
    init(navController: UINavigationController) {
        self.navigationController = navController
        tabbarController = MainTabbarVC(nibName: MainTabbarVC.className, bundle: nil)
        homeNavigationController = UINavigationController()
        homeTabCoordinator = HomeTabCoordinator(navigationController: homeNavigationController!)
        favoritesNavigationController = UINavigationController()
        favoritesTabCoordinator = FavoritesTabCoordinator(navigationController: favoritesNavigationController!)
    }

    
    func start() {
        guard let homeTabCoordinator, let homeNavigationController, let favoritesTabCoordinator, let favoritesNavigationController else { return }
        self.addChild(coordinator: homeTabCoordinator)
        self.addChild(coordinator: favoritesTabCoordinator)
        
        homeTabCoordinator.coordinatorStateClosure = { eventType in // coordinator to coordinator
        }
        
        favoritesTabCoordinator.coordinatorStateClosure = { eventType in // coordinator to coordinator
        }
        
        tabbarController?.coordinatorDelegate = self
        
        
        favoritesTabCoordinator.start()
        homeTabCoordinator.start()
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 0)
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorites", image: nil, tag: 1)
        
        tabbarController?.setViewControllers([homeNavigationController, favoritesNavigationController], animated: true)
        
        DispatchQueue.main.async { [weak self] in
            if let self, let tabbarController = self.tabbarController {
                tabbarController.modalPresentationStyle = .fullScreen
                self.navigationController.present(tabbarController, animated: true)
            }
        }
    }
    
    func reset(completion: (() -> ())?) {
        let group = DispatchGroup()
        
        self.childCoordinators.reversed().forEach { coordinatorItem in
            group.enter()
            coordinatorItem.reset {
                if let presentedController = self.tabbarController?.presentedViewController {
                    group.enter()
                    presentedController.dismiss(animated: false) {
                        group.leave()
                    }
                }
                group.leave()
            }
            removeChild(coordinator: coordinatorItem)
        }
        
        group.notify(queue: .main) {
            completion?()
        }
    }
}

extension MainCoordinator: CoordinatorForVCDelegate {
    // controller to coordinator command
    func coordinatorCommand(type: FlowType) {
        
    }
    
}
