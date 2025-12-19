//
//  TaskModels.swift
//  ToDo Task
//
//  Created by Andrew Hershey on 12/9/25.
//

import Foundation

struct TaskItem: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var title: String
    var isComplete: Bool = false
    
}

struct TaskGroup: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var title: String
    var symbolName: String
    var tasks: [TaskItem]
}
