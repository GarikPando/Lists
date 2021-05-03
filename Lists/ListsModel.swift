//
//  ListsModel.swift
//  Lists
//
//  Created by Игорь Яковлев on 23.04.21.
//

import Foundation

// MARK: - Item model
struct Product: Codable {
    var productName: String = ""
    var productCount: String = ""
    var isChecked: Bool = false
}

// MARK: - Class that handle items model
class ListsModel: NSObject, Codable {
    
    public var listOfProducts = [Product]()
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(ListsModel.self, from: json) {
            self.listOfProducts = newValue.listOfProducts
        }
        else {
            return nil
        }
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - Add new product as ше шы
    public func addProduct(product: Product) {
        listOfProducts.append(product)
        sortList()
    }
    
    // MARK: - Add new product with parsing Name to Name and Count divided by ":"
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
    
    // MARK: - Change product state
    public func changeCheck(index: Int) {
        listOfProducts[index].isChecked = !listOfProducts[index].isChecked
        sortList()
    }
    
    // MARK: - Sorted list by name and state in alfabet order
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
