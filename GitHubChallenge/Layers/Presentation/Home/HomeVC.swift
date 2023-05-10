//
//  HomeVC.swift
//  GitHubChallenge
//
//  Created by namik kaya on 9.05.2023.
//

import UIKit
import CoreData

final class HomeVC: BaseViewController, ControllerBehaviorally {
    typealias P = HomeListProvider
    typealias V = HomeVM
    typealias C = UITableView
    
    private var vm: V?
    private var pr: (any P)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        setupUI()
        addObservationListener()
        //save(id: 123, name: "bla bla", logoUrl: "test/logo")
        //fetch()
        vm?.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func inject(vm: V, provider: any P) {
        self.vm = vm
        self.pr = provider
    }
    
    private func setupUI() {
        self.pr?.setupUI(contentContainer: self.view)
    }
    
}

extension HomeVC {
    func addObservationListener() {
        vm?.stateClosure = { [weak self] eventType in
            switch eventType {
            case .action(let data):
                self?.vmEventHandler(data)
            case .error(let error): break
            }
            
        }
        
        pr?.tableViewStateClosure = { [weak self] eventType in
            switch eventType {
            case .action(let data):
                self?.prEventHandler(data)
            default: break
            }
        }
    }
    
    private func vmEventHandler(_ eventType: HomeVMImpl.UserInteraction?) {
        guard let eventType else { return }
        switch eventType {
        case .updateUI(let data):
            self.pr?.prepareTableView(data: data)
        }
    }
    
    private func prEventHandler(_ eventType: HomeListProviderImpl.TableViewUserInteraction?) {
        guard let eventType else { return }
        switch eventType {
        case .didSelect(let indexPath):
            break
        case .prefetching(let indexPaths):
            vm?.prefetchItemsAt(indexPaths: indexPaths)
        }
    }
}
