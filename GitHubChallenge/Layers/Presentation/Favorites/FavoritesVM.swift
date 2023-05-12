//  FavoritesVM.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 12.05.2023.
//  

import Foundation

protocol FavoritesVM: ViewModel {
    var stateClosure: ( (ObservationType<FavoritesVMImpl.UserInteraction, KError>) -> () )? { get set }
}

final class FavoritesVMImpl: FavoritesVM {
    var stateClosure: ((ObservationType<UserInteraction, KError>) -> ())?
    
    private var useCase: FavoritesUseCase?
    
    var rows:[RowType] = []
    
    init(useCase: FavoritesUseCase){
        self.useCase = useCase
    }
    
    func start(){
        useCase?.fetchLocalRepoList(completion: { [weak self] result in
            switch result {
            case .success(let success):
                self?.prepareUI(data: success)
            case .failure(let failure): break
            }
        })
    }
    
    private func prepareUI(data: [LocalFavoriteEntity]) {
        rows.removeAll()
        data.forEach { item in
            rows.append(.repoItem(repoData: item))
        }
        stateClosure?(.action(data: .updateUI(data: rows)))
    }
}

// MARK: - Events
extension FavoritesVMImpl {
    enum UserInteraction {
        case updateUI(data: [RowType])
    }
    
    enum RowType {
        case repoItem(repoData: LocalFavoriteEntity?)
    }
}
