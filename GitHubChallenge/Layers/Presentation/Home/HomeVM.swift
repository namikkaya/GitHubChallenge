//
//  HomeVM.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import Foundation

protocol HomeVM: ViewModel {
    var stateClosure: ( (ObservationType<HomeVMImpl.UserInteraction, KError>) -> () )? { get set }
    func prefetchItemsAt(indexPaths: [IndexPath])
    func getRepoData(indexPath: IndexPath) -> GoogleRepoListEntity?
    func checkFavorite()
}

final class HomeVMImpl: HomeVM {
    var stateClosure: ((ObservationType<HomeVMImpl.UserInteraction, KError>) -> ())?
    
    private var useCase: HomeUseCase?
    
    private var rows = [RowType]()
    private var dataList: [GoogleRepoListEntity] = []
    
    private var pageNumber: Int = 1
    private var isLoading: Bool = false
    
    private var isFetch: Bool = false
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    func start() {
        fetchFavorites { [weak self] result in
            switch result {
            case .success(let success):
                self?.useCase?.favoritesData = success
            case .failure(let failure):
                self?.stateClosure?(.error(error: failure))
            }
            self?.fetchList()
        }
    }
    
    func checkFavorite() {
        fetchFavorites { [weak self] result in
            switch result {
            case .success(let success):
                self?.useCase?.favoritesData = success
            case .failure(let failure):
                self?.stateClosure?(.error(error: failure))
            }
            let newRowData = self?.prepareUI(data: self?.dataList ?? [])
            self?.rows = newRowData ?? []
            self?.stateClosure?(.action(data: .updateUI(data: self?.rows ?? [])))
        }
    }
}

extension HomeVMImpl {
    func prefetchItemsAt(indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row >= rows.count - 2 }) && !isLoading && !isFetch {
            fetchList()
        }
    }
}

// MARK: - Api
extension HomeVMImpl {
    private func fetchList() {
        isLoading = true
        isFetch = true
        useCase?.fetchGoogleRepoList(pageNumber: self.pageNumber, completion: { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataList.append(contentsOf: data)
                let listData = self?.prepareUI(data: data)
                self?.rows.append(contentsOf: listData ?? [])
                self?.stateClosure?(.action(data: .updateUI(data: self?.rows ?? [])))
                self?.pageNumber += 1
                if (self?.isFetch ?? true) && (self?.useCase?.totalPage ?? 0 ) > 0 && ((self?.pageNumber ?? 0) * (self?.useCase?.perPage ?? 0)) < self?.useCase?.totalPage ?? 0 {
                    self?.isFetch = false
                }
            case .failure(let failure):
                self?.stateClosure?(.error(error: failure))
            }
            self?.isLoading = false
        })
    }
}

// MARK: - Local Data
extension HomeVMImpl {
    private func fetchFavorites (completion: @escaping (Result<[LocalFavoriteEntity], KError>) -> () = {_ in }) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.useCase?.fetchAll(completion: completion)
        }
    }
}

// MARK: - Prepare UI
extension HomeVMImpl {
    private func prepareUI(data: [GoogleRepoListEntity]) -> [RowType] {
        var addRows = [RowType]()
        data.forEach { repoItem in
            addRows.append(.repoItem(repoData: repoItem, isFavorite: useCase?.favoritesData.contains(where: { $0.id == repoItem.id }) ?? false))
        }
        return addRows
    }
    
    func getRepoData(indexPath: IndexPath) -> GoogleRepoListEntity? {
        let rowType = self.rows[indexPath.row]
        switch rowType {
        case .repoItem(let repoData, _):
            return repoData
        }
    }
}

extension HomeVMImpl {
    enum UserInteraction {
        case updateUI(data: [RowType])
    }
    
    enum RowType {
        case repoItem(repoData: GoogleRepoListEntity?, isFavorite: Bool)
    }
}
