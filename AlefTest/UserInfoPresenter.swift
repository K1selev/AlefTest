//
//  UserInfoPresenter.swift
//  AlefTest
//
//  Created by Сергей Киселев on 20.02.2025.
//

import Foundation

protocol UserInfoPresenterProtocol: AnyObject {
    func totalChildrenCount() -> Int
    func getUserInfo() -> CellDataModel
    func getChildInfo(_ index: Int) -> CellDataModel
    func handleNewChildAction()
    func updateFormData(indexPath: IndexPath, text: String?, formType: FormType, cellType: UserInfoHeaderViewStyle)
    func removeChild(indexPath: IndexPath)
    func clearAllData()
}

final class UserInfoPresenter {
    var childrenRecords: [CellDataModel] = []
    var personalData: CellDataModel = CellDataModel()
    
    weak var view: ProfileControllerProtocol?
    
    private func addChild() {
        childrenRecords.append(CellDataModel())
    }
}

extension UserInfoPresenter: UserInfoPresenterProtocol {
    
    func getUserInfo() -> CellDataModel {
        return personalData
    }
    
    func updateFormData(indexPath: IndexPath, text: String?, formType: FormType, cellType: UserInfoHeaderViewStyle) {
        switch cellType {
        case .children:
            switch formType {
            case .age:
                childrenRecords[indexPath.row].age = text
            case .name:
                childrenRecords[indexPath.row].name = text
            }
        case .profile:
            switch formType {
            case .age:
                personalData.age = text
            case .name:
                personalData.name = text
            }
        }
    }
    
    func getChildInfo(_ index: Int) -> CellDataModel {
        return childrenRecords[index]
    }
    
    func totalChildrenCount() -> Int {
        return childrenRecords.count
    }
    
    func removeChild(indexPath: IndexPath) {
        childrenRecords.remove(at: indexPath.row)
        view?.refreshDependentsSection()
    }
    
    func clearAllData() {
        personalData = CellDataModel()
        childrenRecords.removeAll()
        view?.refreshAllSections()
    }
    
    func handleNewChildAction() {
        if childrenRecords.count < 5 {
            addChild()
            view?.refreshDependentsSection()
        }
    }
}

