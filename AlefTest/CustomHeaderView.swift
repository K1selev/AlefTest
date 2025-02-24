//
//  CustomHeaderView.swift
//  AlefTest
//
//  Created by Сергей Киселев on 24.02.2025.
//

import UIKit

enum UserInfoHeaderViewStyle {
    case profile
    case children
}

protocol HeaderDelegate: AnyObject {
    func handleNewChildAction()
}

final class UserInfoHeaderView: UICollectionReusableView {
   
    weak var viewController: HeaderDelegate?
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить ребенка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        
        let spacing: CGFloat = 8
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 8
            config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            button.configuration = config
        } else {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }

        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var headerTitleWidthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerTitle.text = ""
        headerTitleWidthConstraint?.isActive = false
        actionButton.removeFromSuperview()
    }
    
    private func setupUI() {
        addSubview(headerTitle)
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setup(headerStyle: UserInfoHeaderViewStyle, cellsCount: Int) {
        setupHeaderTitle(for: headerStyle)
        
        if headerStyle == .children, cellsCount < 5 {
            configureActionButton()
        }
    }
    
    private func setupHeaderTitle(for style: UserInfoHeaderViewStyle) {
        headerTitle.text = (style == .profile) ? "Персональные данные" : "Дети (макс. 5)"
        
        headerTitleWidthConstraint?.isActive = false
        headerTitleWidthConstraint = headerTitle.widthAnchor.constraint(equalToConstant: (style == .profile) ? 300 : 131)
        headerTitleWidthConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerTitle.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func configureActionButton() {
        addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: headerTitle.trailingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func addButtonTapped() {
        viewController?.handleNewChildAction()
    }
}
