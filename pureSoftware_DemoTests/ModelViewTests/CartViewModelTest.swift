//
//  CartViewModelTest.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import XCTest
import CoreData
@testable import pureSoftware_Demo // Replace YourAppName with the actual name of your app

class CartViewModelTests: XCTestCase {

    var coreDataStack: CoreDataStack!
    var viewModel: CartViewModel!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(inMemory: true) // Use in-memory store for testing
        viewModel = CartViewModel()
       // viewModel.managedObjectContext = coreDataStack.managedObjectContext
    }

    override func tearDown() {
        coreDataStack = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchCartItems() {
        // Insert dummy cart items for testing
        insertDummyCartItems()

        // Fetch cart items using the view model
        viewModel.fetchCartItems()

        // Assert that cart items are fetched successfully
        XCTAssertEqual(viewModel.cartItems.count, 3, "Expected 3 cart items")

        // Assert that total price is updated correctly
        XCTAssertEqual(viewModel.totalPrice, 1000, "Expected total price to be 1000")
    }

    func testDeleteProductFromCart() {
        // Insert dummy cart items for testing
        insertDummyCartItems()

        // Delete a product from the cart
        viewModel.deleteProductFromCart(at: 0)

        // Fetch cart items after deletion
        viewModel.fetchCartItems()

        // Assert that the product is deleted from the cart
        XCTAssertEqual(viewModel.cartItems.count, 2, "Expected 2 cart items after deletion")

        // Assert that total price is updated correctly after deletion
        XCTAssertEqual(viewModel.totalPrice, 500, "Expected total price to be 500 after deletion")
    }


    // Helper method to insert dummy cart items for testing
    private func insertDummyCartItems() {
        let context = coreDataStack.managedObjectContext

        // Create dummy cart items
        let product1 = Product(context: context)
        product1.name = "Television"
        product1.price = 799
        product1.category = "Electronics"
        let cartItem1 = CartItem(context: context)
        cartItem1.relationship = product1
        cartItem1.quantity = 2

        let product2 = Product(context: context)
        product2.name = "Chair"
        product2.price = 49
        product2.category = "Furniture"
        let cartItem2 = CartItem(context: context)
        cartItem2.relationship = product2
        cartItem2.quantity = 1

        let product3 = Product(context: context)
        product3.name = "Table"
        product3.price = 149
        product3.category = "Furniture"
        let cartItem3 = CartItem(context: context)
        cartItem3.relationship = product3
        cartItem3.quantity = 1

        // Save the context
        coreDataStack.saveContext()
    }
    
    
}
