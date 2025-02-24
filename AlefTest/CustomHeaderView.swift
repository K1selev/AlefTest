//
//  CustomHeaderView.swift
//  AlefTest
//
//  Created by Сергей Киселев on 24.02.2025.
//

import UIKit

enum UserInfoHeaderViewStyle {
    case personalInfo
    case kidsInfo
}

protocol HeaderDelegate: AnyObject {
    func didTapAddButton()
}

final class UserInfoHeaderView: UICollectionReusableView {
   
    weak var viewController: HeaderDelegate?
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var headerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить ребенка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        
        let spacing: CGFloat = 8
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)

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
        headerButton.removeFromSuperview()
    }
    
    private func setupUI() {
        addSubview(headerTitle)
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        headerButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setup(headerStyle: UserInfoHeaderViewStyle, cellsCount: Int) {
        setupHeaderTitle(for: headerStyle)
        
        if headerStyle == .kidsInfo, cellsCount < 5 {
            setupHeaderButton()
        }
    }
    
    private func setupHeaderTitle(for style: UserInfoHeaderViewStyle) {
        headerTitle.text = (style == .personalInfo) ? "Персональные данные" : "Дети (макс. 5)"
        
        headerTitleWidthConstraint?.isActive = false
        headerTitleWidthConstraint = headerTitle.widthAnchor.constraint(equalToConstant: (style == .personalInfo) ? 300 : 131)
        headerTitleWidthConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerTitle.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupHeaderButton() {
        addSubview(headerButton)
        NSLayoutConstraint.activate([
            headerButton.leadingAnchor.constraint(equalTo: headerTitle.trailingAnchor, constant: 16),
            headerButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func addButtonTapped() {
        viewController?.didTapAddButton()
    }
}
