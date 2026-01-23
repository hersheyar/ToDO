//
//  TaskGroupDetailView.swift
//  ToDo Task
//
//  Created by Andrew Hershey on 12/9/25.
//

import SwiftUI

struct TaskGroupDetailView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @Binding var groups: TaskGroup

    var body: some View {
        List {
            if groups.tasks.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checklist")
                        .font(.system(size: 28))
                        .foregroundStyle(.secondary)
                    Text("No tasks yet")
                        .font(.headline)
                    Button(action: addTask) {
                        Label {
                            Text("Add your first task")
                        } icon: {
                            Image(systemName: "plus")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .listRowInsets(EdgeInsets())
            } else {
                ForEach($groups.tasks) { $task in
                    HStack(spacing: 12) {
                        Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(task.isComplete ? .cyan : .gray)
                            .onTapGesture {
                                withAnimation { task.isComplete.toggle() }
                            }
                            .accessibilityLabel(Text(task.isComplete ? "mark_incomplete" : "mark_complete"))

                        TextField("task_title_placeholder", text: $task.title)
                            .textFieldStyle(.roundedBorder)
                            .strikethrough(task.isComplete)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.vertical, hSizeClass == .compact ? 4 : 8)
                }
                .onDelete { index in
                    groups.tasks.remove(atOffsets: index)
                }
            }
        }
        .environment(\.editMode, .constant(.active))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: addTask) {
                    Label {
                        Text("add_task")
                    } icon: {
                        Image(systemName: "plus")
                    }
                }
                .accessibilityLabel(Text("add_task"))
            }
        }
    }

    private func addTask() {
        withAnimation { groups.tasks.append(TaskItem(title: "New Task")) }
    }
}

