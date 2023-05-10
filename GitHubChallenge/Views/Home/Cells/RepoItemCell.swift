//
//  RepoItemCell.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import UIKit

class RepoItemCell: UITableViewCell {
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.backgroundColor = .white
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.alignment = .top
        return stack
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fill
        stack.backgroundColor = .white
        return stack
    }()

    lazy var titleLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var followersCount: UILabel = {
        return UILabel()
    }()
    
    lazy var forksCount: UILabel = {
        return UILabel()
    }()
    
    lazy var ownerRepos: UILabel = {
        return UILabel()
    }()
    
    lazy var ownerLogo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    lazy var imageContainer: UIView = {
        return UIView()
    }()
    
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

    func setup(data: GoogleRepoListEntity?) {
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
