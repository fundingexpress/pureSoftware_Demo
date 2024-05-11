//
//  CoreDataStack.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataStack {
  static let shared = CoreDataStack()
    
  var count = 0
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "pureSoftware_Demo")
    container.loadPersistentStores { [weak self] storeDescription, error in
      guard let self = self else { return }
      if let error = error {
        print("Error loading persistent store: \(error.localizedDescription)")
        // Handle the error gracefully, potentially offer retry or fallback options
      }
     
    }
    return container
  }()

  var managedObjectContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  func saveContext() {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        let nsError = error as NSError
        print("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "pureSoftware_Demo") // Replace "pureSoftware_Demo" with your actual Core Data model name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func insertDummyData() {
        let context = CoreDataStack.shared.managedObjectContext

        // Define product names and corresponding prices
        let productsData: [(name: String, price: Int, category: String)] = [
            ("Microwave Oven", 299, "Electronics"),
            ("Television", 799, "Electronics"),
            ("Vacuum Cleaner", 199, "Electronics"),
            ("Table", 149, "Furniture"),
            ("Chair", 49, "Furniture"),
            ("Almirah", 399, "Furniture")
        ]

        // Counter to alternate between categories
        var index = 0

        // Generate 15 random products
        for _ in 0..<15 {
            let (name, price, category) = productsData[index]
            let imageName = "\(name.lowercased().replacingOccurrences(of: " ", with: "_"))" // Generating image name from product name

            createProduct(context: context, name: name, price: Int32(price), category: category, imageName: imageName)

            // Increment or reset index
            index = (index + 1) % productsData.count
        }

        saveContext()
    }




  public func createProduct(context: NSManagedObjectContext, name: String, price: Int32, category: String, imageName: String) {
    let product = Product(context: context) // Assuming Product entity exists
    product.name = name
    product.price = price
    product.category = category
    product.image = imageName // Assuming image is stored as image name/asset name
  }


}


