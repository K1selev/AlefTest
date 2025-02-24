//
//  ViewController.swift
//  AlefTest
//
//  Created by Сергей Киселев on 20.02.2025.
//

import UIKit

private enum CollectionViewIdentifiers {
    static let userInfoCell = "UserInfoCollectionViewCell"
    static let headerView = "UserInfoCollectionHeaderView"
    static let footerView = "UserInfoCollectionFooterView"
}

protocol ProfileViewControllerProtocol: AnyObject {
    func editingEnded(indexPath: IndexPath, text: String?, formType: FormType, cellType: UserInfoHeaderViewStyle)
    func didTapDeleteButton(indexPath: IndexPath)
}

protocol ProfileControllerProtocol: AnyObject {
    func refreshDependentsSection()
    func refreshAllSections()
}

final class UserInfoViewController: UIViewController {
    
    private var presenter: UserInfoPresenterProtocol
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isUserInteractionEnabled = true
        collection.isScrollEnabled = true
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.register(UserInfoCollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewIdentifiers.userInfoCell)
        collection.register(UserInfoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewIdentifiers.headerView)
        collection.register(UserInfoFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewIdentifiers.footerView)
        return collection
    }()
    
    init(presenter: UserInfoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension UserInfoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : presenter.totalChildrenCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewIdentifiers.userInfoCell, for: indexPath) as? UserInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cellsCount = presenter.totalChildrenCount()
        if indexPath.section == 0 {
            cell.setupCell(cellType: .profile, cellData: presenter.getUserInfo(), indexPath: indexPath, cellsCount: cellsCount)
        } else {
            cell.setupCell(cellType: .children, cellData: presenter.getChildInfo(indexPath.row), indexPath: indexPath, cellsCount: cellsCount)
        }
        
        cell.viewController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return setupHeaderView(at: indexPath)
        case UICollectionView.elementKindSectionFooter:
            return setupFooterView(at: indexPath)
        default:
            return UICollectionReusableView()
        }
    }
    
    private func setupHeaderView(at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collection.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewIdentifiers.headerView, for: indexPath) as? UserInfoHeaderView else {
            return UICollectionReusableView()
        }
        let style: UserInfoHeaderViewStyle = indexPath.section == 0 ? .profile : .children
        headerView.setup(headerStyle: style, cellsCount: presenter.totalChildrenCount())
        headerView.viewController = self
        return headerView
    }

    private func setupFooterView(at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = collection.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewIdentifiers.footerView, for: indexPath) as? UserInfoFooterView else {
            return UICollectionReusableView()
        }
        if indexPath.section == 1 {
            footerView.delegate = self
        }
        return footerView
    }
}

extension UserInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 145)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 1 && presenter.totalChildrenCount() > 0 ? CGSize(width: collectionView.frame.width, height: 60) : .zero
    }
}

extension UserInfoViewController: ProfileControllerProtocol {
    func refreshDependentsSection() {
        collection.reloadSections([1])
    }
    
    func refreshAllSections() {
        collection.reloadData()
    }
}

extension UserInfoViewController: HeaderDelegate {
    func handleNewChildAction() {
        presenter.handleNewChildAction()
    }
}

extension UserInfoViewController: ProfileViewControllerProtocol {
    func editingEnded(indexPath: IndexPath, text: String?, formType: FormType, cellType: UserInfoHeaderViewStyle) {
        presenter.updateFormData(indexPath: indexPath, text: text, formType: formType, cellType: cellType)
    }
    
    func didTapDeleteButton(indexPath: IndexPath) {
        presenter.removeChild(indexPath: indexPath)
    }
}

extension UserInfoViewController: FooterDelegate {
    func didTapDeleteAllButton() {
        let alert = UIAlertController(title: "Очистить данные?", message: "Все введённые данные будут удалены", preferredStyle: .actionSheet)
        
        let resetAction = UIAlertAction(title: "Сбросить данные", style: .destructive) { _ in
            self.presenter.clearAllData()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
