//
//  CoreDataStackTest.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import XCTest
import CoreData
@testable import pureSoftware_Demo

class CoreDataStackTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(inMemory: true) // Use in-memory store for testing
    }
    
    override func tearDown() {
        coreDataStack = nil
        super.tearDown()
    }
    
    func testInsertDummyData() {
        // Call the insertDummyData method
        coreDataStack.insertDummyData()
        
        // Fetch products from Core Data and assert that they exist
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            let products = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            XCTAssertFalse(products.isEmpty, "Products should not be empty after inserting dummy data")
        } catch {
            XCTFail("Failed to fetch products: \(error.localizedDescription)")
        }
    }
    
    func testCreateProduct() {
        // Create a new product
        let context = coreDataStack.managedObjectContext
        let productName = "Television"
        let productPrice: Int32 = 799
        let productCategory = "Electronics"
        let productImageName = "television"
        
        coreDataStack.createProduct(context: context, name: productName, price: productPrice, category: productCategory, imageName: productImageName)
        
        // Fetch the created product
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", productName)
        
        do {
            let products = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            XCTAssertEqual(products.count, 1, "One product should be fetched")
            
            // Assert product attributes
            let product = products
            XCTAssertEqual(product[0].name, productName, "Product name should match")
            XCTAssertEqual(product[0].price, productPrice, "Product price should match")
            XCTAssertEqual(product[0].category, productCategory, "Product category should match")
            XCTAssertEqual(product[0].image, productImageName, "Product image name should match")
        } catch {
            XCTFail("Failed to fetch product: \(error.localizedDescription)")
        }
    }
}
