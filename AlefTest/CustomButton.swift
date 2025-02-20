//
//  CustomButton.swift
//  AlefTest
//
//  Created by Сергей Киселев on 20.02.2025.
//

import UIKit

class CustomButton: UIButton {
    init(title: String, color: UIColor, borderColor: UIColor = .clear) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.layer.borderWidth = borderColor == .clear ? 0 : 1
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = 8
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
