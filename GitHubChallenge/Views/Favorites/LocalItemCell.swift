//
//  LocalItemCell.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 12.05.2023.
//

import UIKit

class LocalItemCell: UITableViewCell {
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        return label
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

    func setup(data: LocalFavoriteEntity?) {
        titleLabel.text = data?.name
    }
    

}

extension LocalItemCell {
    private func setupUI() {
        self.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(16)
            make.bottom.equalTo(-16)
        }
    }
}
