//
//  pureSoftware_DemoAppTest.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import XCTest
@testable import pureSoftware_Demo

class pureSoftware_DemoAppTests: XCTestCase {

    func testContentViewInitialization() {
        // Create an instance of CoreDataStack for testing
        let coreDataStack = CoreDataStack(inMemory: true)
        
        // Create an instance of pureSoftware_DemoApp
        let app = pureSoftware_DemoApp()
        
        // Inject the managed object context from the test CoreDataStack into ContentView
        let contentView = ContentView().environment(\.managedObjectContext, coreDataStack.container.viewContext)
        
        // Verify if ContentView is properly initialized
        XCTAssertNotNil(contentView, "ContentView should be initialized")
    }
}
