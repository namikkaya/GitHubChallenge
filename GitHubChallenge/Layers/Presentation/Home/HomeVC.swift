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
        vm?.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isFirstOpen {
            vm?.checkFavorite()
        }
        super.viewWillAppear(animated)
    }
    
    func inject(vm: V, provider: any P) {
        self.vm = vm
        self.pr = provider
    }
    
    private func setupUI() {
        self.pr?.setupUI(contentContainer: self.view)
    }
    
}

// MARK: - Binding
extension HomeVC {
    func addObservationListener() {
        vm?.stateClosure = { [weak self] eventType in
            switch eventType {
            case .action(let data):
                self?.vmEventHandler(data)
            case .error(let error):
                self?.displayError(error)
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
            guard let repoData = vm?.getRepoData(indexPath: indexPath) else { return }
            self.coordinatorDelegate?.coordinatorCommand(eventType: .appFlow(flowType: .mainFlow(flowType: .detail(data: repoData))))
        case .prefetching(let indexPaths):
            vm?.prefetchItemsAt(indexPaths: indexPaths)
        case .openSortPage:
            openSortList()
        case .openTypePage:
            openTypeList()
        }
    }
}


// MARK: - UI Action
extension HomeVC {
    private func displayError(_ err: KError?) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "", message: err?.message ?? KErrorCode.general.errorDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openSortList() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Select Sort Value", message: nil, preferredStyle: .actionSheet)
            self?.vm?.sortList.forEach({ item in
                alert.addAction(UIAlertAction(title: item.rawValue, style: .default, handler: { (action) in
                    self?.vm?.selectedFilterSortType = item
                    self?.vm?.fetchFilter()
                }))
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self?.present(alert, animated: false, completion: nil)
        }
    }
    
    private func openTypeList() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Select Type Value", message: nil, preferredStyle: .actionSheet)
            self?.vm?.typeList.forEach({ item in
                alert.addAction(UIAlertAction(title: item.rawValue, style: .default, handler: { (action) in
                    self?.vm?.selectedFilterType = item
                    self?.vm?.fetchFilter()
                }))
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self?.present(alert, animated: false, completion: nil)
        }
    }
}
