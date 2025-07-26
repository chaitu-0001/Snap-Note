//
//  HomeViewController.swift
//  SnapNote
//
//  Created by chaitanya on 24/05/25.
//

import Foundation
import UIKit
import PDFKit
import CoreData



class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        

        // PDF Button
        let pdfButton = UIButton(type: .system)
        pdfButton.setTitle("View PDF", for: .normal)
        pdfButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        pdfButton.translatesAutoresizingMaskIntoConstraints = false
        pdfButton.addTarget(self, action: #selector(openPDF), for: .touchUpInside)
        view.addSubview(pdfButton)

        // Products Button
        let viewProductsButton = UIButton(type: .system)
        viewProductsButton.setTitle("View Products", for: .normal)
        viewProductsButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        viewProductsButton.translatesAutoresizingMaskIntoConstraints = false
        viewProductsButton.addTarget(self, action: #selector(openProductList), for: .touchUpInside)
        view.addSubview(viewProductsButton)

        NSLayoutConstraint.activate([
            pdfButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pdfButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            viewProductsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewProductsButton.topAnchor.constraint(equalTo: pdfButton.bottomAnchor, constant: 20)
        ])
    }

    @objc func openPDF() {
        guard let url = URL(string: "https://fssservices.bookxpert.co/GeneratedPDF/Companies/nadc/2024-2025/BalanceSheet.pdf") else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let pdfVC = storyboard.instantiateViewController(withIdentifier: "PDFViewerViewController") as? PDFViewerViewController {
            pdfVC.pdfURL = url
            navigationController?.pushViewController(pdfVC, animated: true)
        }
    }

    @objc func openProductList() {
        let productListVC = ProductListViewController()
        navigationController?.pushViewController(productListVC, animated: true)
    }
    

}

