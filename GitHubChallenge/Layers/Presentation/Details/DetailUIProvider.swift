//
//  DetailUIProvider.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 12.05.2023.
//

import UIKit
import SnapKit

protocol DetailUIProvider {
    func setContentContainer(container: UIView)
    func setData(data: GoogleRepoListEntity?, isFavorite: Bool)
    func changeFavoriteButtonStatus(isFavorite: Bool)
    var stateClosure: ( (ObservationType<DetailUIProviderImpl.UserInteraction, Error>) -> () )? { get set }
}

final class DetailUIProviderImpl: DetailUIProvider {
    var stateClosure: ((ObservationType<UserInteraction, Error>) -> ())?
    
    private weak var contentContainer: UIView?

    lazy private var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.backgroundColor = .white
        stack.distribution = .fill
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    lazy private var ownerLogo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.numberOfLines = 0
        myLabel.textAlignment = .center
        return myLabel
    }()
    
    lazy private var followersCount: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy private var forksCount: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy private var ownerRepos: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy private var toggleFavoriteButton: ToggleButton = {
        let button = ToggleButton(frame: CGRect(x: 0, y: 0, width: 120, height: 48), onColor: .red, offColor: .gray)
        button.isOn = false
        return button
    }()
    
    func setContentContainer(container: UIView) {
        self.contentContainer = container
        DispatchQueue.main.async { [weak self] in
            self?.addSubViews()
            self?.addConstraints()
        }
    }
    
    func setData(data: GoogleRepoListEntity?, isFavorite: Bool) {
        titleLabel.text = data?.name
        ownerLogo.load(path: data?.owner?.avatarURL)
        ownerRepos.text = data?.owner?.reposURL
        followersCount.text = "Watcher Count: \(data?.watcherCount ?? 0)"
        forksCount.text = "Fork Count: \(data?.forksCount ?? 0)"
        toggleFavoriteButton.isOn = isFavorite
    }
    
    private func addSubViews() {
        contentContainer?.addSubview(vStack)
        vStack.addArrangedSubview(ownerLogo)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(followersCount)
        vStack.addArrangedSubview(forksCount)
        vStack.addArrangedSubview(ownerRepos)
        vStack.addArrangedSubview(toggleFavoriteButton)
        toggleFavoriteButton.delegate = self
    }
    
    private func addConstraints() {
        vStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(contentContainer?.safeAreaLayoutGuide.snp.top ?? 40).offset(8)
        }
        
        ownerLogo.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
        
        toggleFavoriteButton.snp.makeConstraints { make in
            make.width.equalTo(160)
            make.height.equalTo(48)
        }
    }
    
    func changeFavoriteButtonStatus(isFavorite: Bool) {
        toggleFavoriteButton.isOn = isFavorite
    }
}

extension DetailUIProviderImpl: ToggleButtonDelegate {
    func changeButtonStatus(isOn: Bool) {
        stateClosure?(.action(data: .changeFavoriteStatus(isFavorite: isOn)))
    }
}

extension DetailUIProviderImpl {
    enum UserInteraction {
        case changeFavoriteStatus(isFavorite: Bool)
    }
}
