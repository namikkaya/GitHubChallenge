//
//  ControllerBehaviorally.swift
//  GitHubChallenge
//
//  Created by namik kaya on 8.05.2023.
//

import Foundation

protocol ControllerBehaviorally {
    associatedtype P
    associatedtype V
    associatedtype C
    func inject(vm: V, provider: P)
    func addObservationListener()
    func setupComponet(component: C)
}

extension ControllerBehaviorally {
    func addObservationListener() {}
    func setupComponet(component: C) {}
}


protocol ControllerBehaviorallyWithoutComponent {
    associatedtype P
    associatedtype V
    func inject(vm: V, provider: P)
    func addObservationListener()
}

extension ControllerBehaviorallyWithoutComponent {
    func addObservationListener() {}
}
