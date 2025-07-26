//
//  ProductListViewController.swift
//  SnapNote
//
//  Created by chaitanya on 26/05/25.
//

import Foundation
import CoreData
import UIKit

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var products: [CDProduct] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Products"
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension

        setupTableView()
        fetchAndSaveProducts()
    }

    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        view.addSubview(tableView)
    }

    func fetchAndSaveProducts() {
        NetworkManager.shared.fetchProducts { result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    CoreDataManager.shared.saveProducts(products)
                    self.loadProductsFromCoreData()
                }
            case .failure(let error):
                print("Failed to fetch: \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            let productToDelete = products[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            CoreDataManager.shared.deleteProduct(productToDelete
                                        , in: context)
            
            // Remove from local array and refresh table
            products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func loadProductsFromCoreData() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        do {
            products = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Failed to fetch from Core Data")
        }
    }

    // TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }

        let product = products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
   
}
