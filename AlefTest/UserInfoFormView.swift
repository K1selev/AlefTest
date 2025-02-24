//
//  UserInfoFormView.swift
//  AlefTest
//
//  Created by Сергей Киселев on 24.02.2025.
//


import UIKit

enum FormType {
    case name
    case age
}

protocol FormViewDelegate: AnyObject {
    func editingEnded(formType: FormType, text: String?)
}

final class FormView: UIView {
    
    let formType: FormType
    weak var delegate: FormViewDelegate?
    
    var formStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    var formTitle: UILabel = {
        var formTitle = UILabel()
        formTitle.textAlignment = .left
        formTitle.font = .systemFont(ofSize: 13)
        formTitle.textColor = .gray
        return formTitle
    }()
    
    var formTextField: UITextField = {
        var formTextField = UITextField()
        return formTextField
    }()
    
    init(formType: FormType, frame: CGRect = .zero) {
        self.formType = formType
        super.init(frame: frame)
        formTextField.delegate = self
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        formStackView.addArrangedSubview(formTitle)
        formStackView.addArrangedSubview(formTextField)
        formStackView.layer.borderColor = UIColor.lightGray.cgColor
        formStackView.layer.borderWidth = 1
        formStackView.layer.cornerRadius = 5
        formStackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        formStackView.isLayoutMarginsRelativeArrangement = true
        self.addSubview(formStackView)
        
        formStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            formStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            formStackView.topAnchor.constraint(equalTo: self.topAnchor),
            formStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        switch formType {
        case .name:
            setupNameCell()
        case .age:
            setupAgeCell()
        }
    }
    
    private func setupNameCell() {
        formTitle.text = "Имя"
        formTextField.placeholder = "Введите имя"
    }
    
    private func setupAgeCell() {
        formTitle.text = "Возраст"
        formTextField.placeholder = "Введите возраст"
    }
    
    func setText(text: String?) {
        formTextField.text = text
    }
}

extension FormView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.editingEnded(formType: self.formType, text: textField.text)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.editingEnded(formType: self.formType, text: textField.text)
    }
}

