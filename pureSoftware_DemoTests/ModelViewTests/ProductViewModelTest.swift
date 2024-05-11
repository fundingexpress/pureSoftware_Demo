//
//  ProductViewModel.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import XCTest
import CoreData
@testable import pureSoftware_Demo

class ProductViewModelTests: XCTestCase {

    var viewModel: ProductViewModel?
    var cartViewModel: CartViewModel?
    var coreDataStack: CoreDataStack?

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(inMemory: true)
        viewModel = ProductViewModel()
        cartViewModel = CartViewModel()
    }

    override func tearDown() {
        viewModel = nil
        cartViewModel = nil
        coreDataStack = nil
        super.tearDown()
    }

    func testFetchProducts() {
        // Insert dummy products for testing
        coreDataStack?.insertDummyData()

        // Fetch all products
        viewModel?.fetchProducts()

        // Assert that products are fetched
        XCTAssertEqual(viewModel?.products.count, 15, "Expected 15 products")

        // Fetch products for a specific category
        viewModel?.fetchProducts(for: "Electronics")

        // Assert that products for the specified category are fetched
        XCTAssertEqual(viewModel?.products.count, 3, "Expected 3 products for Electronics category")
    }

    func testFetchCategories() {
        // Insert dummy products with categories for testing
        coreDataStack?.insertDummyData()

        // Fetch categories
        viewModel?.fetchCategories()

        // Assert that categories are fetched
        XCTAssertEqual(viewModel?.categories.count, 2, "Expected 2 categories")
    }

    func testSelectProduct() {
        // Insert dummy products for testing
        coreDataStack?.insertDummyData()

        // Select a product
        viewModel?.selectProduct(at: 0)

        // Assert that the selected product is printed or modify to include assertions based on actual implementation
    }

    func testAddProductToCart() {
        // Insert dummy product for testing
        coreDataStack?.insertDummyData()

        // Fetch products
        viewModel?.fetchProducts()

        // Add a product to the cart
        viewModel?.addProductToCart(product: viewModel!.products[0], quantity: 2)

        // Assert that the product is added to the cart
        XCTAssertEqual(viewModel?.cartItems.count, 1, "Expected 1 cart item")
        XCTAssertEqual(viewModel?.cartItems[0].quantity, 2, "Expected quantity to be 2")
    }

    func testFilteredProducts() {
        // Insert dummy products for testing
        coreDataStack?.insertDummyData()

        // Fetch products
        viewModel?.fetchProducts()

        // Filter products by category and search text
        let filteredProducts = viewModel?.filteredProducts(category: "Electronics", searchText: "Television")

        // Assert that filtered products are fetched
        XCTAssertEqual(filteredProducts?.count, 1, "Expected 1 filtered product")
    }

    func testCalculateTotalPrice() {
        // Insert dummy cart items for testing
        coreDataStack?.insertDummyData()

        // Fetch cart items
        cartViewModel?.fetchCartItems()

        // Calculate total price
        let totalPrice = viewModel?.calculateTotalPrice()

        // Assert that total price is calculated correctly
        XCTAssertEqual(totalPrice, 100, "Expected total price to be 100")
    }

}
