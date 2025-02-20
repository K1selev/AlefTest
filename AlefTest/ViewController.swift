//
//  ViewController.swift
//  AlefTest
//
//  Created by Сергей Киселев on 20.02.2025.
//

import UIKit

protocol UserInfoViewProtocol: AnyObject {
    func reloadChildren()
    func clearData()
}

class UserInfoViewController: UIViewController, UserInfoViewProtocol {
    
    // MARK: - UI Elements
//    private let nameTextField = CustomTextField(placeholder: "Имя")
//    private let ageTextField = CustomTextField(placeholder: "Возраст")
    
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
    
    
    private let addChildButton = CustomButton(title: "+ Добавить ребенка", color: .systemBlue, borderColor: .systemBlue)
    private let clearButton = CustomButton(title: "Очистить", color: .red, borderColor: .red)
    private let childrenStackView = UIStackView()
    
    // MARK: - MVP Properties
    var presenter: UserInfoPresenterProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Информация о пользователе"
        
        let headerLabel = UILabel()
        headerLabel.text = "Персональные данные"
        headerLabel.font = .boldSystemFont(ofSize: 18)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        childrenStackView.axis = .vertical
        childrenStackView.spacing = 16
        childrenStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addChildButton.addTarget(self, action: #selector(addChildTap), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearAllData), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [headerLabel, nameTextField, ageTextField, addChildButton, childrenStackView, clearButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    // MARK: - Actions
    @objc private func addChildTap() {
        presenter.addChild()
    }
    
    @objc private func clearAllData() {
        presenter.showClearActionSheet()
    }
    
    // MARK: - UserInfoViewProtocol
    func reloadChildren() {
        childrenStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        presenter.children.forEach { child in
            let childView = ChildView(child: child)
            childView.removeButton.addTarget(self, action: #selector(removeChild(_:)), for: .touchUpInside)
            childrenStackView.addArrangedSubview(childView)
        }
        addChildButton.isHidden = presenter.children.count >= 5
    }
    
    func clearData() {
        nameTextField.text = ""
        ageTextField.text = ""
        reloadChildren()
    }
    
    @objc private func removeChild(_ sender: UIButton) {
        if let index = childrenStackView.arrangedSubviews.firstIndex(where: { ($0 as? ChildView)?.removeButton == sender }) {
            presenter.removeChild(at: index)
        }
    }
}
