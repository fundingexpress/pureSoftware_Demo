//
//  CartViewModel.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import Foundation
import CoreData

class CartViewModel: ObservableObject {
    
    private let managedObjectContext = CoreDataStack.shared.managedObjectContext
    
    @Published var cartItems: [CartItem] = []
    @Published var totalPrice: Int32 = 0 // Add a published property for total price
    
    func fetchCartItems() {
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()

        do {
            cartItems = try managedObjectContext.fetch(fetchRequest)
         //   print(cartItems)
            updateTotalPrice() // Update total price after fetching cart items
        } catch {
            print("Error fetching cart items: \(error.localizedDescription)")
        }
    }
    
    func deleteProductFromCart(at index: Int) {
        guard index >= 0 && index < cartItems.count else {
            return // Index out of bounds
        }
        
        let cartItemToDelete = cartItems[index]
        managedObjectContext.delete(cartItemToDelete)
        
        cartItems.remove(at: index)
        
        do {
            try managedObjectContext.save()
            updateTotalPrice() // Update total price after deleting a cart item
        } catch {
            print("Error deleting cart item: \(error.localizedDescription)")
        }
    }

    

    // Update total price based on the quantities of cart items
     func updateTotalPrice() {
        totalPrice =  cartItems.reduce(0) { $0 + (($1.relationship?.price ?? 0) * $1.quantity) }
    }
}


