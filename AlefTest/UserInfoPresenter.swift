//
//  UserInfoPresenter.swift
//  AlefTest
//
//  Created by Сергей Киселев on 20.02.2025.
//

import UIKit

protocol UserInfoPresenterProtocol: AnyObject {
    var children: [Child] { get }
    func viewDidLoad()
    func addChild()
    func removeChild(at index: Int)
    func showClearActionSheet()
}

class UserInfoPresenter: UserInfoPresenterProtocol {
    private weak var view: UserInfoViewProtocol?
    private var model: UserInfoModel
    
    var children: [Child] {
        model.children
    }
    
    init(view: UserInfoViewProtocol, model: UserInfoModel) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view?.reloadChildren()
    }
    
    func addChild() {
        guard model.children.count < 5 else { return }
        model.addChild(Child(name: "", age: ""))
        view?.reloadChildren()
    }
    
    func removeChild(at index: Int) {
        model.removeChild(at: index)
        view?.reloadChildren()
    }
    
    func showClearActionSheet() {
        let actionSheet = UIAlertController(title: "Очистить данные", message: "Вы уверены, что хотите сбросить все данные?", preferredStyle: .actionSheet)
        
        let resetAction = UIAlertAction(title: "Сбросить данные", style: .destructive) { _ in
            self.model.clearAllData()
            self.view?.clearData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        actionSheet.addAction(resetAction)
        actionSheet.addAction(cancelAction)
        
        (view as? UIViewController)?.present(actionSheet, animated: true, completion: nil)
    }
}
