//
//  ToDo_TaskUnitTests.swift
//  ToDo TaskUnitTests
//
//  Created by Andrew Hershey on 1/20/26.
//

import Testing
@testable import ToDo_Task

@Suite("ToDo Unit Tests")
struct ToDo_TaskUnitTests {

    @Test("Toggle task completion")
    @MainActor func toggleTaskCompletion() async throws {
        var task = TaskItem(title: "Walk dog", isComplete: false)
        #expect(task.isComplete == false)
        task.isComplete.toggle()
        #expect(task.isComplete == true)
    }

    @Test("Task can have a priority level")
    @MainActor func taskHasPriority() async throws {
        var task = TaskItem(title: "Complete Homework")
        #expect(task.priority == .medium, "Default priority should be .medium")
        task.priority = .high
        #expect(task.priority == .high)
    }
}
