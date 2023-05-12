//
//  DetailsVC.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 11.05.2023.
//

import UIKit

final class DetailsVC: BaseViewController, ControllerBehaviorallyWithoutComponent {
    
    typealias P = DetailUIProvider
    typealias V = DetailVM
    
    private var vm: V?
    private var ui: P?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Detail"
        setupUI(self.view)
        addObservationListener()
        vm?.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isFirstOpen {
            vm?.checkFavorite()
        }
        super.viewWillAppear(animated)
    }
    
    func inject(vm: V, provider: P) {
        self.vm = vm
        self.ui = provider
    }
    
    func addObservationListener() {
        vm?.stateClosure = { [weak self] eventType in
            switch eventType {
            case .action(let event):
                self?.vmEventHandler(event)
            case .error(let error):
                self?.displayError(error)
            }
        }
        
        ui?.stateClosure = { [weak self] eventType in
            switch eventType {
            case .action(let data):
                self?.uiEventHandler(data)
            case .error(let error):
                self?.displayError(error as? KError)
            }
            
        }
    }
    
    private func vmEventHandler(_ eventType: DetailVMImpl.UserInteraction?) {
        switch eventType {
        case .updateUI(let data, let isFavorite):
            self.ui?.setData(data: data, isFavorite: isFavorite)
        case .changeLocalFavoriteStatus(let isFavorite):
            self.ui?.changeFavoriteButtonStatus(isFavorite: isFavorite)
        default: break
        }
    }
    
    private func uiEventHandler(_ eventType: DetailUIProviderImpl.UserInteraction?) {
        switch eventType {
        case .changeFavoriteStatus(let isFavorite):
            vm?.changeFavoriteStatus(isFavorite: isFavorite)
        default: break
        }
    }
}

// MARK: - PrepareUI
extension DetailsVC {
    private func setupUI(_ view: UIView) {
        self.ui?.setContentContainer(container: view)
    }
}

// MARK: - UI Action
extension DetailsVC {
    private func displayError(_ err: KError?) {
        let alert = UIAlertController(title: "", message: err?.message ?? KErrorCode.general.errorDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
             }))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
