//
//  UserInfoModel.swift
//  AlefTest
//
//  Created by Сергей Киселев on 20.02.2025.
//

struct Child {
    var name: String
    var age: String
}

class UserInfoModel {
    private(set) var children: [Child] = []
    
    func addChild(_ child: Child) {
        children.append(child)
    }
    
    func removeChild(at index: Int) {
        children.remove(at: index)
    }
    
    func clearAllData() {
        children.removeAll()
    }
}
