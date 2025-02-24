//
//  UserInfoCollectionView.swift
//  AlefTest
//
//  Created by Сергей Киселев on 24.02.2025.
//

import UIKit

final class UserInfoCollectionViewCell: UICollectionViewCell {
    
    private let nameForm = FormView(formType: .name)
    private let ageForm = FormView(formType: .age)
    
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        return line
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    
    private var cellType: UserInfoHeaderViewStyle?
    private var indexPath: IndexPath?
    weak var viewController: ProfileViewControllerProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [nameForm, ageForm, removeButton, separatorLine].forEach { $0.removeFromSuperview() }
        indexPath = nil
        cellType = nil
    }
    
    private func setupUI() {
        [nameForm, ageForm, removeButton, separatorLine].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupCell(cellType: UserInfoHeaderViewStyle, cellData: CellDataModel, indexPath: IndexPath, cellsCount: Int) {
        self.cellType = cellType
        self.indexPath = indexPath
        
        contentView.addSubview(nameForm)
        contentView.addSubview(ageForm)
        
        if cellType == .children {
            contentView.addSubview(removeButton)
        }
        
        setupConstraints(for: cellType)
        configureForms(with: cellData)
        
        if indexPath.section == 1, indexPath.row < cellsCount - 1 {
            configureDivider()
        }
    }
    
    private func setupConstraints(for cellType: UserInfoHeaderViewStyle) {
        let isKidsInfo = (cellType == .children)
        let formWidthMultiplier: CGFloat = isKidsInfo ? 0.5 : 1.0
        
        NSLayoutConstraint.activate([
            nameForm.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameForm.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameForm.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: formWidthMultiplier),
            nameForm.heightAnchor.constraint(equalToConstant: 60),
            
            ageForm.topAnchor.constraint(equalTo: nameForm.bottomAnchor, constant: 8),
            ageForm.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ageForm.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: formWidthMultiplier),
            ageForm.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        if isKidsInfo {
            NSLayoutConstraint.activate([
                removeButton.centerYAnchor.constraint(equalTo: nameForm.centerYAnchor),
                removeButton.leadingAnchor.constraint(equalTo: nameForm.trailingAnchor, constant: 16)
            ])
        }
    }
    
    private func configureForms(with cellData: CellDataModel) {
        [nameForm, ageForm].forEach { $0.delegate = self }
        nameForm.setText(text: cellData.name)
        ageForm.setText(text: cellData.age)
    }
    
    private func configureDivider() {
        contentView.addSubview(separatorLine)
        NSLayoutConstraint.activate([
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc private func didTapDeleteButton() {
        guard let indexPath else { return }
        contentView.endEditing(true)
        viewController?.didTapDeleteButton(indexPath: indexPath)
    }
}

extension UserInfoCollectionViewCell: FormViewDelegate {
    func editingEnded(formType: FormType, text: String?) {
        guard let indexPath, let cellType else { return }
        viewController?.editingEnded(indexPath: indexPath, text: text, formType: formType, cellType: cellType)
    }
}
