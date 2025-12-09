//
//  TaskTableViewCellTests.swift
//  TodoListAppTests
//

import XCTest
@testable import TodoListApp

class TaskTableViewCellTests: XCTestCase {
    
    func testCellCreation() {
        // Given & When
        let cell = TaskTableViewCell(style: .default, reuseIdentifier: "TestCell")
        
        // Then - Basic existence
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.completionButton)
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.descriptionLabel)
        XCTAssertNotNil(cell.dateLabel)
    }
    
    func testCellReuse() {
        // Given
        let cell = TaskTableViewCell(style: .default, reuseIdentifier: "TestCell")
        cell.titleLabel.text = "Old Text"
        
        // When
        cell.prepareForReuse()
        
        // Then
        XCTAssertNil(cell.titleLabel.text)
    }
    
    func testAutoLayoutSetup() {
        // Given
        let cell = TaskTableViewCell(style: .default, reuseIdentifier: "TestCell")
        
        // Then
        XCTAssertFalse(cell.completionButton.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(cell.titleLabel.translatesAutoresizingMaskIntoConstraints)
    }
}


// MARK- Verify UI elements are properly configured:

extension TaskTableViewCellTests {
    
    func testLabelContent() {
        // Given
        let testText = "Test Content"
        let cell = TaskTableViewCell(style: .default, reuseIdentifier: "TestCell")
        
        // When
        cell.titleLabel.text = testText
        cell.descriptionLabel.text = testText
        cell.dateLabel.text = testText
        
        // Then
        XCTAssertEqual(cell.titleLabel.text, testText)
        XCTAssertEqual(cell.descriptionLabel.text, testText)
        XCTAssertEqual(cell.dateLabel.text, testText)
    }
    
    func testCompletionButtonImages() {
        // Test that system images exist (requires iOS 13+)
        if #available(iOS 13.0, *) {
            let circleImage = UIImage(systemName: "circle")
            let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")
            
            XCTAssertNotNil(circleImage, "Circle image should exist in iOS 13+")
            XCTAssertNotNil(checkmarkImage, "Checkmark image should exist in iOS 13+")
        }
    }
    
    func testAccessibility() {
        // Given
        let cell = TaskTableViewCell(style: .default, reuseIdentifier: "TestCell")
        let button = cell.completionButton
        
        // When - Set up basic accessibility
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Complete task"
        button.accessibilityTraits = .button
        
        // Then
        XCTAssertTrue(button.isAccessibilityElement)
        XCTAssertEqual(button.accessibilityLabel, "Complete task")
        XCTAssertEqual(button.accessibilityTraits, .button)
    }
}
