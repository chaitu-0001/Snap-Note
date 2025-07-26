//
//  CoreDataManager.swift
//  SnapNote
//
//  Created by chaitanya on 26/05/25.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    private init() {
        persistentContainer = NSPersistentContainer(name: "SnapNote") // Use your actual Core Data model name here
             persistentContainer.loadPersistentStores { (description, error) in
                 if let error = error {
                     fatalError("Core Data store failed to load with error: \(error)")
                 }
             }
         }
    
    func saveProducts(_ products: [Product]) {

        let context = persistentContainer.viewContext

        for product in products {
            let cdProduct = CDProduct(context: context)
            cdProduct.id = product.id
            cdProduct.name = product.name

            if let data = product.data {
                cdProduct.color = data.color
                cdProduct.price = data.price ?? 0.0
                cdProduct.generation = data.generation
                cdProduct.productDescription = data.description
                cdProduct.year = Int16(data.year ?? 0)
                cdProduct.cpuModel = data.cpuModel
                cdProduct.hardDiskSize = data.hardDiskSize
                cdProduct.strapColour = data.strapColour
                cdProduct.caseSize = data.caseSize
                cdProduct.screenSize = data.screenSize ?? 0.0

                // Convert "128 GB" → 128
                if let capacity = data.capacity,
                   let capacityInt = Int(capacity.components(separatedBy: " ").first ?? "") {
                    cdProduct.capacityGB = Int16(capacityInt)
                }
            }
        }

        do {
            try context.save()
            print("Products saved to Core Data.")
        } catch {
            print("Error saving products: \(error)")
        }
    }
    
    func fetchProducts() -> [CDProduct] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching products from Core Data: \(error)")
            return []
        }
    }
    
    func deleteProduct(_ product: CDProduct, in context: NSManagedObjectContext) {
        
        let productName = product.name ?? "Unnamed Product"
        context.delete(product)
    
        // Step 1: Log details
        print("Deleting Product:")
        print("ID: \(product.id ?? "N/A")")
        print("Name: \(product.name ?? "N/A")")
        print("Price: \(product.price)")
        print("Color: \(product.color ?? "N/A")")
        
        do {
            try context.save()
            print("Product deleted locally from Core Data.")

            // Step 3: Send a local notification
            sendDeletionNotification(for: productName)

        } catch {
            print("Failed to delete product: \(error.localizedDescription)")
        }
    }

    
    func sendDeletionNotification(for productName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Product Deleted"
        content.body = "\(productName) was removed from your list."
        content.sound = .default

        // Trigger after 1 second
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: \(error.localizedDescription)")
            }
        }
    }
    }
    
