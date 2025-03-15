//
//  AllCategoriesScreenPresenter.swift
//  Shoppe
//
//  Created by Вячеслав on 06.03.2025.
//

import UIKit

protocol AllCategoriesScreenPresenterProtocol: AnyObject {
    init(view: AllCategoriesScreenViewProtocol)
    func cellPressed()
    func getCountsOfCells() -> Int
    func getCellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell
    func getheightForRowAt(indexPath: IndexPath) -> CGFloat
    func didSelectRowAt(indexPath: IndexPath)
}

final class AllCategoriesScreenPresenter: AllCategoriesScreenPresenterProtocol {
    
    let view: AllCategoriesScreenViewProtocol
    
    var categories: [Category] = Category.getCategories()
    var expandedCategories: [CategoryCellItemType] = []
    
    
    init(view: AllCategoriesScreenViewProtocol) {
        self.view = view
        expandedCategories = getTupes()
    }
    
    func cellPressed() {
        view.setTableView()
    }
    
    func getCountsOfCells() -> Int {
        var isExpandedCounts = 0
        for category in categories {
            if category.isExpanded {
                isExpandedCounts += 1
            }
        }
        isExpandedCounts += categories.count
        return isExpandedCounts
    }
    
    func getCellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let category = expandedCategories[indexPath.row]
        switch category {
        case .category(let category):
            let cell = CategoryCell()
            cell.configure(with: category)
            return cell
        case .subcategory(let subCategory):
            let cell = CategoryButtonsCell()
            cell.subcategories = subCategory
            return cell
        }
        
    }
    
    func getheightForRowAt(indexPath: IndexPath) -> CGFloat {
        let category = expandedCategories[indexPath.row]
        switch category {
        case .subcategory(let subCategory):
            // Высота динамическая, в зависимости от количества кнопок
            let rows = (Double(subCategory.count) / 2.0) // 2 кнопки в строке
            return CGFloat(rows * 50 + 16) // Высота кнопки + отступы
         case .category(_):
            return 60
        }
                    
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        let category = expandedCategories[indexPath.row]
        switch category {
        case .category(var categor):
            var index = 0
            for category in categories {
                index += 1
                if category.name == categor.name{
                    
                }
            }
            categories[0].isExpanded.toggle()
    
            expandedCategories = getTupes()
            view.reloadTableView()
        case .subcategory:
            break
        }
        expandedCategories = getTupes()
    }
    
    private func getTupes() -> [CategoryCellItemType] {
        var array = [CategoryCellItemType]()
        for category in categories {
            if category.isExpanded {
                array.append(.category(category))
                array.append(.subcategory(category.subcategories))
            } else {
                array.append(.category(category))
            }
        }
        return array
        
    }
    
    
}

// Структура для данных категории
struct Category {
    let name: String
    let imageName: String
    var isExpanded: Bool
    let subcategories: [String] // Подкатегории (кнопки)
    
    static func getCategories() -> [Category] {
        return [
            Category(name: "Clothing", imageName: "", isExpanded: true, subcategories: ["Dreses", "Pants", "Skirts", "Shorts", "Jackets", "Hoodies", "Shirts", "Polo", "T-Shirts", "Tunics"]), Category(name: "Shoes", imageName: "", isExpanded: false, subcategories: []),
            Category(name: "Bags", imageName: "", isExpanded: false, subcategories: []),
            Category(name: "Lingerie", imageName: "", isExpanded: false, subcategories: []),
            Category(name: "Accessories", imageName: "", isExpanded: false, subcategories: [])
        ]
    }
    
}

enum CategoryCellItemType {
    case category(Category)
    case subcategory([String])
}
