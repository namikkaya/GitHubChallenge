//
//  FavoritesListProvider.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 12.05.2023.
//

import UIKit

protocol FavoritesProvider: TableViewProvider where T == FavoritesVMImpl.RowType, I == IndexPath {
    var tableViewStateClosure: ( (ObservationType<FavoritesProviderImpl.TableViewUserInteraction, Error>) -> () )? { get set }
    func setupUI(contentContainer: UIView)
}


final class FavoritesProviderImpl: NSObject, FavoritesProvider {
    var tableViewStateClosure: ((ObservationType<FavoritesProviderImpl.TableViewUserInteraction, Error>) -> ())?
    
    var dataList: [FavoritesVMImpl.RowType] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    func setupUI(contentContainer: UIView) {
        contentContainer.addSubview(tableView)
        setupTableView(tableView: tableView)
        
        addConstraint(container: contentContainer)
    }
    
    private func addConstraint(container: UIView) {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(container.safeAreaLayoutGuide.snp.top)
        }
    }
    
}

extension FavoritesProviderImpl: UITableViewDelegate, UITableViewDataSource {
    func setupTableView(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.registerWithoutNib(cellType: LocalItemCell.self)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = dataList[indexPath.row]
        switch rowType {
        case .repoItem(let repoData):
            let cell = tableView.dequeueReusableCell(with: LocalItemCell.self, for: indexPath)
            cell.setup(data: repoData)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItem(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func prepareTableView(data: [FavoritesVMImpl.RowType]) {
        self.dataList = data
        reloadTableView()
    }
    
    func didSelectItem(indexPath: IndexPath) {
        tableViewStateClosure?(.action(data: .didSelect(indexPath: indexPath)))
    }
}

extension FavoritesProviderImpl {
    enum TableViewUserInteraction {
        case didSelect(indexPath: IndexPath)
    }
}
