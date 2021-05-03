//
//  VariableHeader.swift
//  Lists
//
//  Created by Игорь Яковлев on 22.04.21.
//

import Foundation
import UIKit

// Таблица с изменяемым верхним заголовком
final class VariableHeader: UIView, UITextFieldDelegate
{
    //изображение для шапки таблицы
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        //imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    public weak var mainVC: UIViewController?
    
    
    private let addButton: UIButton = {
        let addButton = UIButton(type: .system)
        addButton.setTitle("", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = .white
        addButton.alpha = 0.8
        addButton.isUserInteractionEnabled = true
        addButton.isEnabled = true
        addButton.setImage(.add, for: .normal)
        addButton.layer.cornerRadius = 5
        addButton.addTarget(self, action: #selector(AddProduct), for: .touchUpInside)
        return addButton
    }()
    
    @objc func AddProduct(_ sender: UIButton! = nil) {
        if let VC = mainVC as? ViewController, let text = addTextField.text {
            addTextField.text = nil
            VC.addProductInMode(text)
            
            addTextField.resignFirstResponder()
            getBackTextKeyboard()
        }
    }

    private let addTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " + product : count"
        textField.backgroundColor = .white
        textField.alpha = 0.8
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        return textField
    }()
    
    
    private var imageViewHight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHight = NSLayoutConstraint()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //добавляем в контейнер изображение и все это помещаем во вью
    private func createViews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        
        containerView.addSubview(addButton)
        containerView.addSubview(addTextField)
        addTextField.delegate = self
        
        addLeftButtonOnKeyboard()
    }
    
    // настраиваем констрейны
    func setViewConstraints() {
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        //определяем положение главного контейнера
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHight.isActive = true
        //определяем положение картинки
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHight.isActive = true
        //определяем положение кнопки добавления
        addButton.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -10).isActive = true
        addButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10).isActive = true
        addButton.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1/10).isActive = true
        addButton.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/8).isActive = true
        //определяем положение поля для нового продукта
        addTextField.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 10).isActive = true
        addTextField.rightAnchor.constraint(equalTo: addButton.leftAnchor, constant: -10).isActive = true
        addTextField.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10).isActive = true
        addTextField.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1/10).isActive = true
        //addTextField.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/1.3).isActive = true
    }
    
    // обновляем отображение картинки в результате скрола
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHight.constant = scrollView.contentInset.top
        let offSetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offSetY <= 0
        imageViewBottom.constant = offSetY >= 0 ? 0 : -offSetY / 2
        imageViewHight.constant = max(offSetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addTextField {
            self.addTextField.resignFirstResponder()
            self.AddProduct()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == addTextField {
            //self.addTextField.becomeFirstResponder()
        }
        return true
    }
    
    
    func addLeftButtonOnKeyboard(){
        let buttonToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        buttonToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let countItem: UIBarButtonItem = UIBarButtonItem(title: " : count", style: UIBarButtonItem.Style.plain, target: self, action: #selector(changeKeyboard))
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addByKeyboard))
        
        let items = NSMutableArray()
        items.add(countItem)
        items.add(flexSpace)
        items.add(done)
        
        buttonToolbar.items = items as? [UIBarButtonItem]
        buttonToolbar.sizeToFit()
        self.addTextField.inputAccessoryView = buttonToolbar
        
    }
    
    func getBackTextKeyboard() {
        self.addTextField.keyboardType = .default
        self.addTextField.reloadInputViews()
    }
    
    @objc func changeKeyboard() {
        guard !self.addTextField.text!.isEmpty else {
            return
        }
        
        guard !self.addTextField.text!.contains(":") else {
            return
        }
      
        self.addTextField.text! += ": "
        self.addTextField.keyboardType = .numbersAndPunctuation
        self.addTextField.reloadInputViews()
    
    }
    
    @objc func addByKeyboard() {
        self.addTextField.resignFirstResponder()
        self.AddProduct()
        getBackTextKeyboard()
        
    }
}
