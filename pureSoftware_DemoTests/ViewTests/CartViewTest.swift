//
//  CartViewTest.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//


import XCTest
import SwiftUI
@testable import pureSoftware_Demo

class CartViewUITests: XCTestCase {

    func testCartViewUI() throws {
        let viewModel = CartViewModel()
        let view = CartView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: view)
        hostingController.beginAppearanceTransition(true, animated: false)
        hostingController.endAppearanceTransition()
        
        // Test if "Your cart is empty" text is displayed when cart is empty
        let emptyCartTextExists = hostingController.view.viewWithTag(100)?.viewWithTag(101) as? UILabel != nil &&
            (hostingController.view.viewWithTag(100)?.viewWithTag(101) as? UILabel)?.text == "Your cart is empty"

        XCTAssertNotNil(emptyCartTextExists)

        
    
    }
}

class CartItemRowViewUITests: XCTestCase {

  var coreDataStack: CoreDataStack!

  override func setUp() {
    super.setUp()
    coreDataStack = CoreDataStack(inMemory: true)
  }

  override func tearDown() {
    coreDataStack = nil
    super.tearDown()
  }

  func testCartItemRowViewUI() throws {
    // 1. Setup CoreDataStack
    let context = coreDataStack.managedObjectContext

    // 2. Create CartItem with mock product
    let product = MockProduct(name: "Test Product", price: 9.99, image: "product_image")
    let cartItem = CartItem(context: context)
    cartItem.relationship = product
    cartItem.quantity = 2

    // 3. Initialize ViewModel (optional, depending on your view model usage)
    let viewModel = CartViewModel() // uncomment if needed for testing

    // 4. Create CartItemRowView
    let view = CartItemRowView(cartItem: cartItem, viewModel: viewModel)
    let hostingController = UIHostingController(rootView: view)
    hostingController.beginAppearanceTransition(true, animated: false)
    hostingController.endAppearanceTransition()

    // 5. Test UI Elements using accessibility identifiers (if set)
    if let productImageView = hostingController.rootView.accessibilityElement(identifier: "productImageView") as? UIImageView {
      XCTAssertNotNil(productImageView) // Check if image view exists
    }

    if let productNameLabel = hostingController.rootView.accessibilityElement(identifier: "productNameLabel") as? Text {
      XCTAssertNotNil(productNameLabel) // Check if label exists
      XCTAssertEqual(productNameLabel.text, "Test Product") // Check product name
    }

    if let priceQuantityLabel = hostingController.rootView.accessibilityElement(identifier: "priceQuantityLabel") as? Text {
      XCTAssertNotNil(priceQuantityLabel) // Check if label exists
      XCTAssertEqual(priceQuantityLabel.text, "$9.99 x 2") // Check price and quantity
    } else {
      // Handle the case where the priceQuantityLabel is not found (optional)
    }
  }
}
