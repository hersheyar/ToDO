//
//  TaskModels.swift
//  ToDo Task
//
//  Created by Andrew Hershey on 12/9/25.
//

import Foundation

enum Priority: Int, Codable, CaseIterable, Comparable {
    case low = 0
    case medium = 1
    case high = 2

    static func < (lhs: Priority, rhs: Priority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct TaskItem: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var title: String
    var priority: Priority = .medium
    var isComplete: Bool = false
    
}

struct TaskGroup: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var title: String
    var symbolName: String
    var tasks: [TaskItem]
}
