//
//  SplashVM.swift
//  GitHubChallenge
//
//  Created by namik kaya on 9.05.2023.
//

import Foundation

protocol SplashVM: ViewModel {
    var stateClosure: ( (ObservationType<SplashVMImpl.UserInteraction, Error>) -> () )? { get set }
}

final class SplashVMImpl: SplashVM {
    var stateClosure: ((ObservationType<UserInteraction, Error>) -> ())?
    
    private var timer: Timer?
    
    func start() {
        startTimer()
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] timer in
            self?.stateClosure?(.action(data: .gotoMain))
            self?.stopTimer()
        })
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
}

extension SplashVMImpl {
    enum UserInteraction {
        case gotoMain
    }
}
