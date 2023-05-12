//
//  FavoritesVC.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import UIKit

final class FavoritesVC: BaseViewController, ControllerBehaviorally {
    
    typealias P = FavoritesProvider
    
    typealias V = FavoritesVM
    
    typealias C = UITableView
    
    private var vm:V?
    private var ui:(any P)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        addObservationListener()
        ui?.setupUI(contentContainer: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm?.start()
    }
    
    func inject(vm: V, provider: any P) {
        self.vm = vm
        self.ui = provider
    }
    
    private func displayError(_ err: KError?) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "", message: err?.message ?? KErrorCode.general.errorDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
}


// MARK: - Binding
extension FavoritesVC {
    func addObservationListener() {
        vm?.stateClosure = { [weak self] eventType in
            switch eventType {
            case .action(let data):
                self?.vmEventHandler(data)
            case .error(let error):
                self?.displayError(error)
            }
            
        }
        
        ui?.tableViewStateClosure = { [weak self] eventType in
            switch eventType {
            case .action(let data):
                self?.prEventHandler(data)
            default: break
            }
        }
    }
    
    private func vmEventHandler(_ eventType: FavoritesVMImpl.UserInteraction?) {
        guard let eventType else { return }
        switch eventType {
        case .updateUI(let data):
            self.ui?.prepareTableView(data: data)
        }
    }
    
    private func prEventHandler(_ eventType: FavoritesProviderImpl.TableViewUserInteraction?) {
        guard let eventType else { return }
        switch eventType {
        case .didSelect: break
        }
    }
}
