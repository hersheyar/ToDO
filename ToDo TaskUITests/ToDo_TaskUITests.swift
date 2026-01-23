//
//  ToDo_TaskUITests.swift
//  ToDo TaskUITests
//
//  Created by Andrew Hershey on 1/20/26.
//

import XCTest

final class ToDo_TaskUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()

        
    }

    @MainActor
    func testAddGroupAndVerifyInList() throws {
        let app = XCUIApplication()
        app.launch()

  
        let addGroupButton = app.buttons.matching(identifier: "add_group").firstMatch
        XCTAssertTrue(addGroupButton.waitForExistence(timeout: 3), "Add Group toolbar button should exist")
        addGroupButton.tap()

       
        let newGroupAlert = app.alerts["New Group"]
        XCTAssertTrue(newGroupAlert.waitForExistence(timeout: 3), "New Group alert should appear")

        let textField = newGroupAlert.textFields.firstMatch
        XCTAssertTrue(textField.exists, "New Group alert should contain a text field")
        let uniqueTitle = "Test Group \(Int(Date().timeIntervalSince1970))"
        textField.tap()
        textField.typeText(uniqueTitle)

        let createButton = newGroupAlert.buttons["Create"]
        XCTAssertTrue(createButton.exists, "Create button should exist in New Group alert")
        createButton.tap()

       
        let newGroupCell = app.staticTexts[uniqueTitle].firstMatch
        XCTAssertTrue(newGroupCell.waitForExistence(timeout: 3), "Newly created group should appear in the list")
    }

    @MainActor
    func testLaunchPerformance() throws {
    
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}

