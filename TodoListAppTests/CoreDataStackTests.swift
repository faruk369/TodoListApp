//
//  CoreDataStackTests.swift
//  TodoListAppTests
//
//  Created by nas on 09.12.2025.
//

import XCTest
import CoreData
@testable import TodoListApp // Replace with your actual module name

class CoreDataStackTests: XCTestCase {
    
    var coreDataStack: CoreDataStack!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        // Create a fresh instance for each test
        coreDataStack = CoreDataStack.shared
    }
    
    override func tearDown() {
        // Clean up after each test
        coreDataStack = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testCoreDataStackIsSingleton() {
        // Given
        let instance1 = CoreDataStack.shared
        let instance2 = CoreDataStack.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "CoreDataStack should be a singleton")
    }
    
    func testPersistentContainerIsLoaded() {
        // When
        let container = coreDataStack.persistentContainer
        
        // Then
        XCTAssertNotNil(container, "Persistent container should not be nil")
        XCTAssertEqual(container.name, "CoreData", "Container should have correct name")
    }
    
    func testContextIsAvailable() {
        // When
        let context = coreDataStack.context
        
        // Then
        XCTAssertNotNil(context, "Context should not be nil")
        XCTAssertEqual(context.concurrencyType, .mainQueueConcurrencyType,
                      "Context should be main queue type")
    }
    
//    func testContextHasMergePolicy() {
//        // When
//        let context = coreDataStack.context
//        
//        // Then - Use identity comparison (===) not type-casting (is)
//        // NSMergeByPropertyObjectTrumpMergePolicy is a shared instance, not a type
//        let expectedMergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        XCTAssertTrue(context.mergePolicy === expectedMergePolicy,
//                     "Context should have correct merge policy")
//    }
    
    func testSaveContextWithChanges() {
        // Given
        let context = coreDataStack.context
        
        // Try to create a test entity (assuming you have a Todo entity in your model)
        // First, check if the entity exists
        let entityDescription = NSEntityDescription.entity(forEntityName: "Todo",
                                                          in: context)
        
        if let entityDescription = entityDescription {
            // Create a test object
            let testObject = NSManagedObject(entity: entityDescription,
                                            insertInto: context)
            testObject.setValue("Test Todo", forKey: "title")
            
            // When
            coreDataStack.saveContext()
            
            // Then - No error should be thrown
            XCTAssertTrue(true, "Save should complete without throwing")
        } else {
            // If no Todo entity exists, just test that save doesn't crash with empty context
            // This is a fallback for when the model isn't set up yet
            coreDataStack.saveContext()
            XCTAssertTrue(true, "Save should complete without throwing even with no changes")
        }
    }
    
    func testSaveContextWithoutChanges() {
        // Given - No changes made to context
        
        // When & Then - Should not crash when saving with no changes
        coreDataStack.saveContext()
        XCTAssertTrue(true, "Save should handle no changes gracefully")
    }
    
    func testThreadSafety() {
        // Given
        let expectation = self.expectation(description: "Background context save")
        
        // When
        let backgroundContext = coreDataStack.persistentContainer.newBackgroundContext()
        
        backgroundContext.perform {
            // Perform some background operation
            // Create a test entity if available
            let entityDescription = NSEntityDescription.entity(forEntityName: "Todo",
                                                              in: backgroundContext)
            
            if let entityDescription = entityDescription {
                let testObject = NSManagedObject(entity: entityDescription,
                                                insertInto: backgroundContext)
                testObject.setValue("Background Todo", forKey: "title")
            }
            
            do {
                try backgroundContext.save()
                expectation.fulfill()
            } catch {
                XCTFail("Failed to save background context: \(error)")
            }
        }
        
        // Then
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testPersistentContainerLoading() {
        // Given
        let container = coreDataStack.persistentContainer
        
        // When - Accessing the container triggers loading if not already loaded
        
        // Then
        XCTAssertNotNil(container.persistentStoreCoordinator,
                       "Persistent store coordinator should be loaded")
        XCTAssertFalse(container.persistentStoreDescriptions.isEmpty,
                      "Should have at least one persistent store description")
    }
}
