//
//  SplashUIProvider.swift
//  GitHubChallenge
//
//  Created by namik kaya on 9.05.2023.
//

import UIKit
import SnapKit

protocol SplashUIProvider {
    func setContentContainer(container: UIView)
}

final class SplashUIProviderImpl: SplashUIProvider {
    private weak var contentContainer: UIView?
    lazy var label: UILabel = {
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.textAlignment = .center
        return myLabel
    }()
    
    func setContentContainer(container: UIView) {
        self.contentContainer = container
        DispatchQueue.main.async { [weak self] in
            self?.addSubViews()
            self?.addConstraints()
        }
        label.text = "SplashVC Screen"
    }
    
    private func addSubViews() {
        contentContainer?.addSubview(self.label)
    }
    
    private func addConstraints() {
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension SplashUIProviderImpl {
    enum UserInteraction {
        case gotoMain
    }
}
