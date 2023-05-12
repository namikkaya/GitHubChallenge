//
//  ToggleButton.swift
//  GitHubChallenge
//
//  Created by NAMIK KAYA on 12.05.2023.
//

import UIKit

protocol ToggleButtonDelegate: AnyObject {
    func changeButtonStatus(isOn: Bool)
}

final class ToggleButton: UIButton {
    weak var delegate: ToggleButtonDelegate?
    var isOn: Bool = false {
        didSet {
            toggle()
        }
    }
    
    private let onColor: UIColor
    private let offColor: UIColor
    
    init(frame: CGRect, onColor: UIColor, offColor: UIColor) {
        self.onColor = onColor
        self.offColor = offColor
        super.init(frame: frame)
        
        layer.cornerRadius = frame.height / 2
        backgroundColor = offColor
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        isOn = !isOn
        delegate?.changeButtonStatus(isOn: isOn)
    }
    
    private func toggle() {
        backgroundColor = isOn ? onColor : offColor
        let title = isOn ? "Remove Favorite" : "Added Favorite"
        setTitle(title, for: .normal)
    }
}
