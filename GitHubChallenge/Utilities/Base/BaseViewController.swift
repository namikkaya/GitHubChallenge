//
//  BaseViewController.swift
//  GitHubChallenge
//
//  Created by namik kaya on 9.05.2023.
//

import UIKit

class BaseViewController: UIViewController {
    weak var coordinatorDelegate: CoordinatorForVCDelegate?
    var isFirstOpen: Bool = true
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFirstOpen = false
    }
}
