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
}

final class HomeVMImpl: HomeVM {
    var stateClosure: ((ObservationType<HomeVMImpl.UserInteraction, KError>) -> ())?
    
    private let useCase: HomeUseCase?
    
    private var rows = [RowType]()
    
    private var pageNumber: Int = 1
    private var isLoading: Bool = false
    
    private var isFetch: Bool = false
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    func start() {
        fetchList()
        /*useCase?.fetchAll(completion: { [weak self] result in
            switch result {
            case .success(let success):
                
                break
            case .failure(let failure):
                
                break
            }
        })*/
    }
}

extension HomeVMImpl {
    func prefetchItemsAt(indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row >= rows.count - 2 }) && !isLoading && !isFetch {
            fetchList()
        }
    }
}

extension HomeVMImpl {
    private func fetchList() {
        isLoading = true
        isFetch = true
        useCase?.fetchGoogleRepoList(pageNumber: self.pageNumber, completion: { [weak self] result in
            switch result {
            case .success(let data):
                self?.saveLocalData(data: data.first)
                let listData = self?.prepareUI(data: data, pageNumber: self?.pageNumber ?? 1)
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
    
    private func saveLocalData(data: GoogleRepoListEntity?) {
        guard let data else { return }
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.useCase?.localSave(data: data, completion: { result in
                switch result {
                case .success(let success):
                    
                    break
                case .failure(let failure):
                    
                    break
                }
            })
        }
    }
}

extension HomeVMImpl {
    private func prepareUI(data: [GoogleRepoListEntity], pageNumber: Int) -> [RowType] {
        var addRows = [RowType]()
        data.forEach { repoItem in
            addRows.append(.repoItem(repoData: repoItem))
        }
        return addRows
    }
}

extension HomeVMImpl {
    enum UserInteraction {
        case updateUI(data: [RowType])
    }
    
    enum RowType {
        case repoItem(repoData: GoogleRepoListEntity?)
    }
}
