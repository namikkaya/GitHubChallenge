//
//  TableViewProvider.swift
//  GitHubChallenge
//
//  Created by namik kaya on 8.05.2023.
//

import UIKit

protocol TableViewProvider {
    associatedtype T
    associatedtype I
    var dataList: [T] { get set }
    func setupTableView(tableView: UITableView)
    func didSelectItem(indexPath: I)
    func prepareTableView(data: [T])
    func reloadTableView()
}

extension TableViewProvider {
    func didSelectItem(indexPath: I) {}
    func reloadTableView() {}
}
