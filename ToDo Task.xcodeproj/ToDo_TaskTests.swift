//
//  ToDo_TaskTests.swift
//  ToDo TaskTests
//
//  Created by Andrew Hershey on 1/20/26.
//

import XCTest
@testable import ToDo_Task

final class ToDo_TaskTests: XCTestCase {

    func testCreateGroupAddTaskAndPersistRoundTrip() throws {
        // Create a group and a task
        var group = TaskGroup(title: "Errands", symbolName: "cart.fill", tasks: [])
        let task = TaskItem(title: "Buy milk", isCompleted: false)
        group.tasks.append(task)

        // Save using Persistence helper
        var groups = [group]
        Persistence.saveTaskGroups(groups)

        // Load back
        let loaded = Persistence.loadTaskGroups()
        XCTAssertNotNil(loaded, "Loaded groups should not be nil")
        guard let loadedGroups = loaded else { return }

        // Validate content
        XCTAssertEqual(loadedGroups.count, 1, "There should be exactly one group after round-trip")
        XCTAssertEqual(loadedGroups[0].title, "Errands")
        XCTAssertEqual(loadedGroups[0].tasks.count, 1)
        XCTAssertEqual(loadedGroups[0].tasks[0].title, "Buy milk")
        XCTAssertFalse(loadedGroups[0].tasks[0].isCompleted)
    }

    func testToggleTaskCompletion() throws {
        var task = TaskItem(title: "Walk dog", isCompleted: false)
        XCTAssertFalse(task.isCompleted)
        task.isCompleted.toggle()
        XCTAssertTrue(task.isCompleted)
    }
}
