# Introduction to iPadOS – ToDo App

## Overview
This project is a simple iPadOS SwiftUI app that demonstrates:
- iPad-first navigation using NavigationSplitView (sidebar + detail).
- Multitasking awareness via resizable windows and adaptive layouts.
- Size class–aware UI that adapts to portrait and landscape.
- Basic localization scaffolding (English) using Localizable.strings.

## Key Components
- ContentView.swift: Hosts a NavigationSplitView with a sidebar list of task groups and a detail pane. Toolbar includes a toggle for the sidebar and an Add Group button. The layout adds padding based on size class for better iPad ergonomics.
- TaskGroupDetailView.swift: Shows tasks for the selected group with inline editing, a completion toggle, and an Add Task toolbar action. Spacing scales with size class for comfortable touch targets on iPad.
- ToDo_TaskApp.swift: Defines a WindowGroup with a localized title, a default window size, and content-size-based resizability to behave well in iPad multitasking modes.
- TaskModels.swift: Simple models for TaskItem and TaskGroup with sample data.

## iOS vs iPadOS – What’s Different
- Layout scale and density: iPadOS expects multi-column layouts and larger touch targets. We use NavigationSplitView for a native sidebar+detail experience.
- Multitasking: iPad apps commonly run side-by-side or in Slide Over. The app uses adaptive layout and window resizability so it remains usable at compact and regular sizes.
- Input and orientation: iPad supports keyboard/trackpad and frequent orientation changes. The UI adapts using size classes and SwiftUI’s responsive layout primitives.

## iPadOS Features Used
- NavigationSplitView for split view navigation.
- Window resizing and adaptive padding for comfortable layouts across size classes.
- Support for portrait and landscape; the views respond to size class changes.

## Multitasking (Split View & Slide Over)
Run the app in the iPad simulator. Use the Multitasking menu (… button) to place the app:
- Side-by-side with another app (Split View). The sidebar remains accessible; detail content adapts.
- As a floating panel (Slide Over). The compact size class reduces padding for better use of space.

## Localization (English only)
- Keys live in Base.lproj/Localizable.strings and en.lproj/Localizable.strings.
- The UI references localized strings via Text("key") or LocalizedStringKey.
- Included keys:
  - app_title, add_group, add_task, toggle_sidebar,
  - select_group_title, select_group_message,
  - task_title_placeholder, mark_complete, mark_incomplete

## How to Run
1. Open the Xcode project.
2. Select an iPad simulator (e.g., iPad Pro) and run.
3. Try Split View/Slide Over using the multitasking controls to observe responsive behavior.

## Notes
- No third-party dependencies.
- Minimal, English-only localization as required by the assignment.
# ToDO
