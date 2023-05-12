//
//  RepoItemCell.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import UIKit

final class RepoItemCell: UITableViewCell {
    lazy private var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.backgroundColor = .white
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.alignment = .top
        return stack
    }()
    
    lazy private var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fill
        stack.backgroundColor = .white
        return stack
    }()

    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        return label
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
    
    lazy private var favView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    lazy private var ownerLogo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    lazy private var imageContainer: UIView = {
        return UIView()
    }()
    
    private var data: GoogleRepoListEntity?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupUI()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(data: GoogleRepoListEntity?, isFavorite: Bool) {
        favView.isHidden = !isFavorite
        titleLabel.text = data?.name
        ownerRepos.text = data?.owner?.reposURL
        followersCount.text = "Watcher Count: \(data?.watcherCount ?? 0)"
        forksCount.text = "Fork Count: \(data?.forksCount ?? 0)"
        ownerLogo.load(path: data?.owner?.avatarURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ownerLogo.cancelDownload()
        ownerLogo.image = nil
    }
}


extension RepoItemCell {
    private func setupUI() {
        self.addSubview(hStack)
        hStack.addArrangedSubview(favView)
        hStack.addArrangedSubview(imageContainer)
        hStack.addArrangedSubview(vStack)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(ownerRepos)
        vStack.addArrangedSubview(followersCount)
        vStack.addArrangedSubview(forksCount)
        imageContainer.addSubview(ownerLogo)
    }
    
    private func setupConstraints() {
        hStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(16)
            make.bottom.equalTo(-16)
        }
        
        favView.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalToSuperview()
        }
        
        imageContainer.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.top.bottom.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview()
        }
        
        ownerLogo.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.top.leading.trailing.equalToSuperview()
        }
        
        vStack.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(ownerLogo.snp.height)
        }
    }
}
