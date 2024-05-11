//
//  ProductViewModel.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import Foundation
import CoreData

class ProductViewModel: ObservableObject {
    
    // Core Data managed object context
    private let managedObjectContext = CoreDataStack.shared.managedObjectContext
    
    // Array to hold fetched products
    @Published var products: [Product] = []
    
    // Array to hold cart items
    @Published var cartItems: [CartItem] = []
    
    @Published var categories: [String] = []

    
    // Fetch products from Core Data
     func fetchProducts(for category: String? = nil) {
         let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
         
         // Apply category filter if provided
         if let category = category {
             fetchRequest.predicate = NSPredicate(format: "category == %@", category)
         }
         
         do {
             // Fetch products from Core Data and assign to the products array
             products = try managedObjectContext.fetch(fetchRequest)
             
             // Extract unique categories from fetched products
             if category != nil{
                 categories = Array(Set(products.map { $0.category ?? "" }))
             }
         } catch {
             print("Error fetching products: \(error.localizedDescription)")
         }
     }
 
    
    // Fetch categories from Core Data
    func fetchCategories() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.propertiesToFetch = ["category"]
        fetchRequest.returnsDistinctResults = true

        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            let categories = results.compactMap { $0.category }
            self.categories = Array(Set(categories)) // Convert to Set to remove duplicates and then back to Array
        } catch {
            print("Error fetching categories: \(error.localizedDescription)")
        }
    }
    // Method to handle product selection
    func selectProduct(at index: Int) {
        guard index >= 0 && index < products.count else {
            return // Invalid index
        }
        
        let selectedProduct = products[index]
        // Implement logic to handle the selected product
        print("Selected product: \(selectedProduct.name)")
    }
    
    // Method to add product to cart
    func addProductToCart(product: Product, quantity: Int32 = 1) {
        // Check if the product already exists in the cart
        if let existingCartItem = cartItems.first(where: { $0.relationship == product }) {
            // Increment quantity if product already exists in cart
            existingCartItem.quantity += quantity
        } else {
            // Create a new cart item for the product
            let newCartItem = CartItem(context: managedObjectContext)
            newCartItem.relationship = product
            newCartItem.quantity = quantity
            
            // Add the new cart item to the cartItems array
            cartItems.append(newCartItem)
            
            // Save the cart item to Core Data
            CoreDataStack.shared.saveContext()
        }
    }

    
    //Filter product
    func filteredProducts(category: String?, searchText: String) -> [Product] {
          var filteredProducts = products
          
          // Filter by category
          if let category = category {
              filteredProducts = filteredProducts.filter { $0.category == category }
          }
          
          // Filter by name (case insensitive)
          if !searchText.isEmpty {
              filteredProducts = filteredProducts.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
          }
          
          return filteredProducts
      }
    
    // Method to calculate total price of items in the cart
    func calculateTotalPrice() -> Int32 {
        return cartItems.reduce(0) { $0 + (($1.relationship?.price ?? 0) * Int32($1.quantity)) }
    }
}
