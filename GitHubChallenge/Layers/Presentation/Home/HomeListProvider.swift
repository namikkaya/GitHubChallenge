//
//  HomeListProvider.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import UIKit
import SnapKit

protocol HomeListProvider: TableViewProvider where T == HomeVMImpl.RowType, I == IndexPath {
    var tableViewStateClosure: ( (ObservationType<HomeListProviderImpl.TableViewUserInteraction, Error>) -> () )? { get set }
    func setupUI(contentContainer: UIView)
}


final class HomeListProviderImpl: NSObject, HomeListProvider {
    var tableViewStateClosure: ((ObservationType<TableViewUserInteraction, Error>) -> ())?
    
    var dataList: [HomeVMImpl.RowType] = []
    
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

extension HomeListProviderImpl: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func setupTableView(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.registerWithoutNib(cellType: RepoItemCell.self)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.prefetchDataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = dataList[indexPath.row]
        switch rowType {
        case .repoItem(let repoData):
            let cell = tableView.dequeueReusableCell(with: RepoItemCell.self, for: indexPath)
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
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        self.tableViewStateClosure?(.action(data: .prefetching(indexPaths: indexPaths)))
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func prepareTableView(data: [HomeVMImpl.RowType]) {
        self.dataList = data
        reloadTableView()
    }
    
    func didSelectItem(indexPath: IndexPath) {
        tableViewStateClosure?(.action(data: .didSelect(indexPath: indexPath)))
    }
}

extension HomeListProviderImpl {
    enum TableViewUserInteraction {
        case didSelect(indexPath: IndexPath), prefetching(indexPaths: [IndexPath])
    }
}
