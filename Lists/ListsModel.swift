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

// MARK: - Notification listsModelIsChanged
extension Notification.Name {
    static let listsModelIsChanged = Notification.Name("listsModelIsChanged")
}

// MARK: - Class that handle items model
class ListsModel: NSObject, Codable {
    
    //Shopping list
    public var listOfProducts = [Product]()
    
    //Model in JSON
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    // MARK: - Post notification about changing state of model
    public func modelIsChanged() {
        NotificationCenter.default.post(Notification(name: Notification.Name.listsModelIsChanged))
    }
    
    // MARK: - Initialization
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
    
    // MARK: - Add new product as it is
    public func addProduct(product: Product) {
        listOfProducts.append(product)
        sortList()
        //send notification
        modelIsChanged()
    }
    
    // MARK: - Delete product
    public func removeProduct(by itemPos: Int) {
        listOfProducts.remove(at: itemPos)
        //send notification
        modelIsChanged()
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
        //send notification
        modelIsChanged()
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
    
    // MARK: - JSON
    public func saveModel() {
        if let documentURL  = try? FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("lists.json") {
            if let jsonData = json {
                do {
                    try jsonData.write(to: documentURL)
                    print("The data was saved")
                } catch let error {
                    print("The data coudn't saved because of error: \(error)")
                }
            }
        }
    }
    
}
