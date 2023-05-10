//
//  UIImageView+Ext.swift
//  GitHubChallenge
//
//  Created by namik kaya on 10.05.2023.
//

import Foundation
import Kingfisher

extension UIImageView {
    func load(path: String?, placeHolder: UIImage? = UIImage(named: "placeHolder"), contentMode: UIView.ContentMode = .scaleAspectFit) {
        kf.setImage(with: URL(string: path ?? ""), placeholder: placeHolder, options: [.cacheMemoryOnly]) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.contentMode = .center
            case .success:
                self.contentMode = contentMode
            }
        }

    }
    
    func cancelDownload() {
        kf.cancelDownloadTask()
    }
    
    func preparePlaceHolder(img: UIImage? = UIImage(named: "placeHolder")) {
        self.image = img
        self.contentMode = .scaleAspectFit
    }
}
