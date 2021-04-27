//
//  CustomTableCell.swift
//  Lists
//
//  Created by Игорь Яковлев on 24.04.21.
//

import UIKit

class CustomTableCell: UITableViewCell {

    // MARK: - Cell Identifyer
    static let identifier = "CustumCell"
    
    // MARK: - Lables
    var productNameLabel: UILabel = {
        let productNameLabel = UILabel()
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return productNameLabel
    }()
    
    var productCountLabel: UILabel = {
        let productNameCount = UILabel()
        productNameCount.translatesAutoresizingMaskIntoConstraints = false
        productNameCount.textAlignment = .center
        return productNameCount
    }()
    
    // MARK: - Config layout
    func setupView() {
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productCountLabel)
    }
    
    func setViewConstraints(){
        productNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        productNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 4/5).isActive = true
        productNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        productCountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        productCountLabel.leftAnchor.constraint(equalTo: productNameLabel.rightAnchor).isActive = true
        productCountLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setViewConstraints()
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        let path = UIBezierPath()
//        let startPoint = CGPoint.init(x: 30, y: 50)
//        let stopPoint = CGPoint.init(x: 400, y: 50)
//        path.move(to: startPoint)
//        path.addLine(to: stopPoint)
//        path.close()
//        UIColor.red.set()
//        path.lineWidth = 10
//        path.stroke()
//    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
