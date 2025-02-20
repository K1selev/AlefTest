//
//  ChildView.swift
//  AlefTest
//
//  Created by Сергей Киселев on 20.02.2025.
//

import UIKit

class ChildView: UIView {
    let nameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.floatingPlaceholder = "Имя"
        return textField
    }()

    let ageTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.floatingPlaceholder = "Возраст"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let removeButton = CustomButton(title: "Удалить", color: .systemBlue)
    
    init(child: Child) {
        super.init(frame: .zero)
        nameTextField.text = child.name
        ageTextField.text = child.age
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, ageTextField, removeButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
