//
//  Categories.swift
//  CoinTail
//
//  Created by Eugene on 15.06.23.
//

import UIKit
import RealmSwift


final class Categories {
    
    static let shared = Categories()
    
    var totalCategories = [CategoryClass]()
    
    var categories: [CategoryClass] {
        get {
            return RealmService.shared.categoriesArr
        }
    }
    var subcategories: [SubcategoryClass] {
        get {
            return RealmService.shared.subcategoriesArr
        }
    }
    
    // Иконки для создаваемых категорий
    var createCategoryImages = [
        "trash",
        "text.book.closed",
        "graduationcap",
        "mustache",
        "die.face.3",
        "stethoscope",
        "theatermasks",
        "airplane",
        "bicycle",
        "fuelpump"
    ]
    
    // Получить категории по типам на главном меню
    func getCategories(for sectionType: RecordType) -> [CategoryClass] {
        switch sectionType {
        case .expense:
            return totalCategories.filter { $0.type == "Expense" }
        case .income:
            return totalCategories.filter { $0.type == "Income" }
        case .allOperations:
            return totalCategories
        }
    }
        
    //  Добавление новой категории
    func addNewCategory(_ category: CategoryClass, type: RecordType) {
        RealmService.shared.write(category, CategoryClass.self)
    }
    
    //  Добавление новой подкатегории
    func addNewSubcategory(_ subcategory: SubcategoryClass) {
        RealmService.shared.write(subcategory, SubcategoryClass.self)
    }
    
    func addSubcategoryToCategory(for categoryID: ObjectId, to type: RecordType, subcategoryID: ObjectId) {
        guard var category = categories.first(where: { $0.id == categoryID }) else { return }
        
        //TODO: realm!!!
        category.subcategories.append(subcategoryID)

        RealmService.shared.update(category, CategoryClass.self)
    }
    
    // Обновить категории в коллекции
    func categoriesUpdate(records: [RecordClass]) {
        var newCategories = [CategoryClass]()
                
        for record in records where !newCategories.contains(where: { $0.id == record.categoryID }) {
            guard let category = getCategory(for: record.categoryID) else { return }

            newCategories.append(category)
        }
        
        totalCategories = newCategories
    }
    
    // Получить ID категории по ее названию
    func getCategoryID(for name: String, type: RecordType) -> ObjectId? {
        return categories.filter { $0.name == name }.first?.id
    }
    
    // Получить категорию по ID
    func getCategory(for id: ObjectId) -> CategoryClass? {
        return categories.filter { $0.id == id }.first
    }
    
    // Получить подкатегорию по ID
    func getSubcategory(for id: ObjectId) -> SubcategoryClass? {
        return subcategories.filter { $0.id == id }.first
    }
    
    // Отредактировать категорию по его ID
    func editCategory(for id: ObjectId, replacingCategory: CategoryClass, completion: ((Bool) -> Void)? = nil) {
        RealmService.shared.update(replacingCategory, CategoryClass.self)
        
        completion?(true)
    }
    
    // Отредактировать подкатегорию по его ID
    func editSubcategory(for id: ObjectId, replacingSubcategory: SubcategoryClass, completion: ((Bool) -> Void)? = nil) {
        RealmService.shared.update(replacingSubcategory, SubcategoryClass.self)
        
        completion?(true)
    }
    
    // Удаляет категорию по его ID
    func deleteCategory(for id: ObjectId, completion: ((Bool) -> Void)? = nil) {
        guard let category: CategoryClass = getCategory(for: id) else {
            completion?(false)
            return
        }

        RealmService.shared.delete(category, CategoryClass.self)

        completion?(true)
    }
    
    // Удаляет подкатегорию по его ID
    func deleteSubcategory(for id: ObjectId, completion: ((Bool) -> Void)? = nil) {
        guard let subcategory: SubcategoryClass = getSubcategory(for: id) else {
            completion?(false)
            return
        }
        
        RealmService.shared.delete(subcategory, SubcategoryClass.self)

        completion?(true)
    }
    
}
