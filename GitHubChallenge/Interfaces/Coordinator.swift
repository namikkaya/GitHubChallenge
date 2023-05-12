//
//  Coordinator.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 11.05.2023.
//

import UIKit

protocol Coordinator: NSObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var coordinatorStateClosure: ((CoordinatorEventType) -> ())? { get set }
    func start()
    func reset(completion: @escaping () -> ())
    func addChild(coordinator: Coordinator)
    func removeChild(coordinator: Coordinator)
    func finishViewController(controller: UIViewController)
}

extension Coordinator {
    func addChild(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== coordinator })
    }
    
    func start() {}
    func reset(completion: @escaping () -> () = {}) {}
    func finishViewController(controller: UIViewController) {}
}

enum CoordinatorEventType {
    case finishCoordinator(coordinator: Coordinator)
}

protocol SubCoordinator: Coordinator{
    
}

protocol CoordinatorForVCDelegate: AnyObject {
    func coordinatorCommand(eventType: FlowType)
}

enum FlowType {
    case appFlow(flowType: AppFlow)
}

enum AppFlow {
    case mainFlow(flowType: MainFlow)
}

enum MainFlow {
    case home, detail(data: GoogleRepoListEntity?)
}
