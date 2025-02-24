//
//  CustomFooterView.swift
//  AlefTest
//
//  Created by Сергей Киселев on 24.02.2025.
//

import UIKit

protocol FooterDelegate: AnyObject {
    func didTapDeleteAllButton()
}

final class UserInfoFooterView: UICollectionReusableView {
   
    private lazy var clearDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("Очистить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapDeleteAllButton), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: FooterDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(clearDataButton)
        clearDataButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            clearDataButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            clearDataButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            clearDataButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            clearDataButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func didTapDeleteAllButton() {
        superview?.endEditing(true)
        delegate?.didTapDeleteAllButton()
    }
}
