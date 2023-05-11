//
//  AppCoordinator.swift
//  GitHubChallenge
//
//  Created by namik kaya on 9.05.2023.
//

import UIKit

final class AppCoordinator: NSObject, Coordinator {
    var coordinatorStateClosure: ((CoordinatorEventType) -> ())?

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    deinit {
        print("XYZ: \(self.className) deinit")
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        let splashVC = SplashBuilderImpl().build(delegate: self)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController.pushViewController(splashVC, animated: true)
        }
    }
    
    func reset(completion: (() -> ())?) {
        let group = DispatchGroup()
        self.childCoordinators.reversed().forEach { coordinatorItem in
            group.enter()
            coordinatorItem.reset {
                if let presentedController = self.navigationController.presentedViewController {
                    group.enter()
                    presentedController.dismiss(animated: true) { [weak self] in
                        group.leave()
                        self?.navigationController.popToRootViewController(animated: false)
                    }
                }else {
                    self.navigationController.popToRootViewController(animated: false)
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

// MARK: - Controller To Coordinator
extension AppCoordinator: CoordinatorForVCDelegate {
    // controller to Coordinator command
    func coordinatorCommand(eventType: FlowType) {
        switch eventType {
        case .appFlow(let type):
            switch type {
            case .mainFlow(let flowType):
                mainFlowHandler(flowType)
            }
        default: break
        }
    }
    
    private func mainFlowHandler(_ eventType: MainFlow) {
        switch eventType {
        case .home:
            mainFlow()
        case .detail:break
            
        }
    }
}

// MARK: - Flow Route
extension AppCoordinator {
    private func mainFlow() {
        let mainCoordinator = MainCoordinator(navController: self.navigationController)
        mainCoordinator.coordinatorStateClosure = { [weak self] eventType in
            switch eventType {
            case .finishCoordinator(let coordinator):
                self?.removeChild(coordinator: coordinator)
            }
        }
        self.addChild(coordinator: mainCoordinator)
        mainCoordinator.start()
    }
}
