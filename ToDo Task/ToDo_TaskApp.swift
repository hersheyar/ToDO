//
//  ToDo_TaskApp.swift
//  ToDo Task
//
//  Created by Andrew Hershey on 12/9/25.
//

import SwiftUI

@main
struct ToDo_TaskApp: App {
    var body: some Scene {
        WindowGroup("app_title") {
            ContentView()
        }
        .defaultSize(width: 800, height: 600)
        .windowResizability(.contentSize)
    }
}
