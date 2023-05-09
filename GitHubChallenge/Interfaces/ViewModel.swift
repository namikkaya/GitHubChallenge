//
//  ViewModel.swift
//  GitHubChallenge
//
//  Created by namik kaya on 8.05.2023.
//

import Foundation

protocol ViewModel {
    func start()
}

extension ViewModel {
    func start() {}
}

enum ObservationType<T, E> {
    case action(data: T? = nil), error(error: E?)
}
