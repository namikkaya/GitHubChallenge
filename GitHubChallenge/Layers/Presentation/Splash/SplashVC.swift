//
//  SplashVC.swift
//  GitHubChallenge
//
//  Created by namik kaya on 9.05.2023.
//

import UIKit

final class SplashVC: BaseViewController, ControllerBehaviorallyWithoutComponent {
    typealias P = SplashUIProvider
    typealias V = SplashVM
    
    private var vm: V?
    private var ui: P?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI(self.view)
        addObservationListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm?.start()
    }
    
    func inject(vm: V, provider: P) {
        self.vm = vm
        self.ui = provider
    }
    
    func addObservationListener() {
        vm?.stateClosure = { [weak self] eventType in
            switch eventType {
            case .action(let data):
                self?.vmEventHandler(data)
            default: break
            }
        }
    }
    
    private func vmEventHandler(_ eventType: SplashVMImpl.UserInteraction?) {
        switch eventType {
        case .gotoMain:
            self.coordinatorDelegate?.coordinatorCommand(eventType: .appFlow(flowType: .mainFlow(flowType: .home)))
        default: break
        }
    }
}

extension SplashVC {
    private func setupUI(_ view: UIView) {
        self.ui?.setContentContainer(container: view)
    }
}
