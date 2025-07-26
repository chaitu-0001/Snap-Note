//
//  ProductTableViewCell.swift
//  SnapNote
//
//  Created by chaitanya on 26/05/25.
//

import UIKit
import CoreData

class ProductTableViewCell: UITableViewCell {
    let nameLabel = UILabel()
    let detailsLabel = UILabel()


    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .boldSystemFont(ofSize: 16)
        detailsLabel.font = .systemFont(ofSize: 14)
        nameLabel.numberOfLines = 0
        detailsLabel.numberOfLines = 0
        

        let stack = UIStackView(arrangedSubviews: [nameLabel, detailsLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false 

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with product: CDProduct) {
        nameLabel.text = product.name

        let detailText = """
        Price: \(product.price)
        Year: \(product.year)
        Generation: \(product.generation ?? "N/A")
        Color: \(product.color ?? "N/A")
        Capacity: \(product.capacityGB) GB
        CPU: \(product.cpuModel ?? "N/A")
        Hard Disk: \(product.hardDiskSize ?? "N/A")
        Strap Colour: \(product.strapColour ?? "N/A")
        Case Size: \(product.caseSize ?? "N/A")
        Screen Size: \(product.screenSize)
        Description: \(product.productDescription ?? "N/A")
        """

        detailsLabel.text = detailText
    }
}
