//
//  UserInfoPresenter.swift
//  AlefTest
//
//  Created by Сергей Киселев on 20.02.2025.
//

import Foundation

protocol UserInfoPresenterProtocol: AnyObject {
    func numberOfCells() -> Int
    func personalDataForCell() -> CellDataModel
    func kidsDataForCell(_ index: Int) -> CellDataModel
    func didTapAddButton()
    func saveData(indexPath: IndexPath, text: String?, formType: FormType, cellType: UserInfoHeaderViewStyle)
    func deleteItem(indexPath: IndexPath)
    func deleteAllItems()
}

final class UserInfoPresenter {
    var kidsData: [CellDataModel] = []
    var personalData: CellDataModel = CellDataModel()
    
    weak var view: UserInfoViewControllerProtocol?
    
    private func addChild() {
        kidsData.append(CellDataModel())
    }
}

extension UserInfoPresenter: UserInfoPresenterProtocol {
    
    func personalDataForCell() -> CellDataModel {
        return personalData
    }
    
    func saveData(indexPath: IndexPath, text: String?, formType: FormType, cellType: UserInfoHeaderViewStyle) {
        switch cellType {
        case .kidsInfo:
            switch formType {
            case .age:
                kidsData[indexPath.row].age = text
            case .name:
                kidsData[indexPath.row].name = text
            }
        case .personalInfo:
            switch formType {
            case .age:
                personalData.age = text
            case .name:
                personalData.name = text
            }
        }
    }
    
    func kidsDataForCell(_ index: Int) -> CellDataModel {
        return kidsData[index]
    }
    
    func numberOfCells() -> Int {
        return kidsData.count
    }
    
    func deleteItem(indexPath: IndexPath) {
        kidsData.remove(at: indexPath.row)
        view?.reloadKidsSection()
    }
    
    func deleteAllItems() {
        personalData = CellDataModel()
        kidsData.removeAll()
        view?.reloadData()
    }
    
    func didTapAddButton() {
        if kidsData.count < 5 {
            addChild()
            view?.reloadKidsSection()
        }
    }
}

