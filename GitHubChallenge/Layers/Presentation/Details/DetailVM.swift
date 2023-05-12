//
//  DetailVM.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 12.05.2023.
//

import Foundation

protocol DetailVM: ViewModel {
    var stateClosure: ( (ObservationType<DetailVMImpl.UserInteraction, KError>) -> () )? { get set }
    func changeFavoriteStatus(isFavorite: Bool)
    func checkFavorite()
}

final class DetailVMImpl: DetailVM {
    var stateClosure: ((ObservationType<DetailVMImpl.UserInteraction, KError>) -> ())?
    private var useCase: DetailUseCase
    private var data: GoogleRepoListEntity?
    private var favorites: [LocalFavoriteEntity] = []
    
    init(useCase: DetailUseCase, data: GoogleRepoListEntity?) {
        self.useCase = useCase
        self.data = data
    }
    
    func start() {
        checkFavorite()
    }
    
    func checkFavorite() {
        guard let data, let id = data.id else { return }
        useCase.checkDataExists(id: id) { [weak self] result in
            switch result {
            case .success(let success):
                self?.stateClosure?(.action(data: .updateUI(data: data, isFavorite: success)))
            case .failure:
                self?.stateClosure?(.action(data: .updateUI(data: data, isFavorite: false)))
            }
        }
    }
    
    func changeFavoriteStatus(isFavorite: Bool) {
        isFavorite ? addFavorite() : deleteFavorite(id: data?.id)
    }
    
    private func addFavorite() {
        useCase.localSave(data: data) { [weak self] result in
            switch result {
            case .success(let success):
                success ? self?.checkFavorite() : self?.stateClosure?(.error(error: KError(errorCode: KErrorCode.general)))
            case .failure(let failure):
                self?.stateClosure?(.error(error: failure))
            }
        }
    }
    
    private func deleteFavorite(id: Int?) {
        guard let id else { return }
        useCase.deleteRecord(id: id) { [weak self] result in
            switch result {
            case .success(let success):
                success ? self?.checkFavorite() : self?.stateClosure?(.error(error: KError(errorCode: KErrorCode.general)))
            case .failure(let failure):
                self?.stateClosure?(.error(error: failure))
            }
        }
    }
}

extension DetailVMImpl {
    enum UserInteraction {
        case updateUI(data: GoogleRepoListEntity?, isFavorite: Bool), changeLocalFavoriteStatus(isFavorite: Bool)
    }
}
