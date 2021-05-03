//
//  ViewController.swift
//  Lists
//
//  Created by Игорь Яковлев on 22.04.21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate
{
    // MARK: - View configuration
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        //tableView.allowsSelection = true
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = listStr.map {list.addProduct(product: Product(productName: $0, productCount: "2", isChecked: false)) }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.allowsSelection = true
        let header = VariableHeader(frame: CGRect(x: 0, y: 0,
                                                  width: view.frame.size.width,
                                                  height: view.frame.size.width))
        header.imageView.image = UIImage(named: "Image")
        header.mainVC = self
        tableView.tableHeaderView = header
        
//        if let documentURL = try? FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("lists.json") {
//
//        }
        
    }
    
    //MARK: - Model
    var list = ListsModel()
    var listStr = ["Хлебушек","Молочко","Гречечка","Маслице","Яйки","Сметанушка","Подорожниковый сбор","Лавандовый раф",
                   "Пифко","Чипсеки","Мусильжбанчик","Сладкый пончек","Орешек солоноватый","Ммм данон"]
    
    func addProductInMode(_ productName: String) {
        guard !productName.isEmpty else {
            return
        }
        let product = Product(productName: productName, productCount: "", isChecked: false)
        list.addProduct(product: product, isNeedParseName: true)
        tableView.reloadData()
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.listOfProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.identifier, for: indexPath) as! CustomTableCell
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: list.listOfProducts[indexPath.row].productName)
        
        //форматируем дабл для отображения как целые числа
//        let formatter = NumberFormatter()
//        formatter.minimumFractionDigits = 0
//        formatter.maximumFractionDigits = 2
//        formatter.numberStyle = .decimal
//        let countString = formatter.string(from: list.listOfProducts[indexPath.row].productCount as NSNumber)
        
        let attributeCount: NSMutableAttributedString = NSMutableAttributedString(string: list.listOfProducts[indexPath.row].productCount)

        
        if list.listOfProducts[indexPath.row].isChecked {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            cell.productNameLabel.textColor = .lightGray
            cell.productCountLabel.textColor = .lightGray
        }
        else {
            cell.productNameLabel.textColor = .black
            cell.productCountLabel.textColor = .black
        }
        //cell.textLabel?.attributedText = attributeString
        cell.productNameLabel.attributedText = attributeString
        cell.productCountLabel.attributedText = attributeCount
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchCell(_:)))
        tapRecognizer.numberOfTapsRequired = 2
        tapRecognizer.delegate = self
        cell.addGestureRecognizer(tapRecognizer)
        cell.tag = indexPath.row
        return cell
    }
    
    // MARK: - Touch to unlist
    @objc func touchCell(_ recognizer: UITapGestureRecognizer) {
        print("double tap!")
        
    }
    
    // MARK: - Get out of list
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        list.changeCheck(index: indexPath.row)
        tableView.reloadData()
        return nil
    }
    
    // MARK: - Delete Rows
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            list.listOfProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    // MARK: - Change Header by Scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? VariableHeader else {
            return
        }
        header.scrollViewDidScroll(scrollView: scrollView )
    }
    
}
