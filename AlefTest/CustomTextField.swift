//
//  CustomTextField.swift
//  AlefTest
//
//  Created by Сергей Киселев on 20.02.2025.
//

import UIKit

class CustomTextField: UITextField {

    private let floatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.alpha = 0.0
        return label
    }()

    var floatingPlaceholder: String? {
        didSet {
            placeholder = floatingPlaceholder
            floatingLabel.text = floatingPlaceholder
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        borderStyle = .roundedRect
        font = UIFont.systemFont(ofSize: 16)
        addSubview(floatingLabel)
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        floatingLabel.frame = CGRect(x: 5, y: -10, width: bounds.width - 10, height: 15)
    }

    @objc private func editingChanged() {
        if let text = self.text, !text.isEmpty {
            showFloatingLabel()
        } else {
            hideFloatingLabel()
        }
    }

    private func showFloatingLabel() {
        UIView.animate(withDuration: 0.2) {
            self.floatingLabel.alpha = 1.0
            self.floatingLabel.transform = CGAffineTransform(translationX: 0, y: -10)
        }
    }

    private func hideFloatingLabel() {
        UIView.animate(withDuration: 0.2) {
            self.floatingLabel.alpha = 0.0
            self.floatingLabel.transform = .identity
        }
    }
}
