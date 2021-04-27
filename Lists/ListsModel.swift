//
//  ListsModel.swift
//  Lists
//
//  Created by Игорь Яковлев on 23.04.21.
//

import Foundation

struct Product {
    var productName: String = ""
    var productCount: String = ""
    var isChecked: Bool = false
}

class ListsModel: NSObject {
    
    public var listOfProducts = [Product]()
    
    // MARK: - Добавляем новую запись как есть
    public func addProduct(product: Product) {
        listOfProducts.append(product)
        sortList()
    }
    
    // MARK: - Добавляем новую, в которой парсим имя на имя и количество
    public func addProduct(product: Product, isNeedParseName: Bool) {
        if !product.productName.contains(":") {
            addProduct(product: product)
        } else {
            let components = product.productName.components(separatedBy: ":")
            if components.count >= 2 {
                let newProduct = Product(productName: components[0], productCount: components[1].trimmingCharacters(in: .whitespaces), isChecked: product.isChecked)
                addProduct(product: newProduct)
            }
        }
    }
    
    // MARK: - Смена состояния записи
    public func changeCheck(index: Int) {
        listOfProducts[index].isChecked = !listOfProducts[index].isChecked
        sortList()
    }
    
    // MARK: - Сортировка списка по алфавиту + состояние
    private func sortList(){
        var listActive = listOfProducts.filter { !$0.isChecked }
        var listNotActive = listOfProducts.filter { $0.isChecked }
        listActive.sort { (a, b) -> Bool in
            a.productName < b.productName
        }
        listNotActive.sort { (a, b) -> Bool in
            a.productName < b.productName
        }
        listOfProducts = listActive + listNotActive
    }
}
