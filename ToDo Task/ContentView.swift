//
//  ContentView.swift
//  ToDo Task
//
//  Created by Andrew Hershey on 12/9/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @State private var taskGroups: [TaskGroup] = []
    @State private var selectedGroup: TaskGroup?
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    @AppStorage("appearanceOverride") private var appearanceOverrideRawValue: String?
    @State private var overrideScheme: ColorScheme? = nil 
    @AppStorage("selectedGroupID") private var storedSelectedGroupID: String?
    @State private var isPresentingNewGroupPrompt = false
    @State private var newGroupTitle: String = ""
    @State private var isPresentingRenamePrompt = false
    @State private var renameTitle: String = ""

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedGroup) {
                if taskGroups.isEmpty {
                    Section {
                        VStack(spacing: 12) {
                            Image(systemName: "folder.badge.plus")
                                .font(.system(size: 28))
                                .foregroundStyle(.secondary)
                            Text("no_groups_yet")
                                .font(.headline)
                            Button(action: { isPresentingNewGroupPrompt = true }) {
                                Label {
                                    Text("add_group")
                                } icon: {
                                    Image(systemName: "plus")
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .listRowInsets(EdgeInsets())
                    }
                }
                ForEach(taskGroups) { group in
                    NavigationLink(value: group) {
                        Label {
                            Text(group.title)
                        } icon: {
                            Image(systemName: group.symbolName)
                        }
                    }
                }
                .onDelete(perform: deleteGroups)
                
                Section("Sketch") {
                    NavigationLink {
                        DrawingScreen()
                    } label: {
                        Label("Sketch", systemImage: "pencil.and.outline")
                    }
                }
            }
            .navigationTitle(Text("app_title"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: toggleSidebar) {
                        Image(systemName: "sidebar.leading")
                    }
                    .accessibilityLabel(Text("toggle_sidebar"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isPresentingNewGroupPrompt = true }) {
                        Label {
                            Text("add_group")
                        } icon: {
                            Image(systemName: "plus")
                        }
                    }
                    .accessibilityLabel(Text("add_group"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            overrideScheme = nil
                            appearanceOverrideRawValue = nil
                        } label: {
                            Label("System Appearance", systemImage: overrideScheme == nil ? "checkmark" : "")
                        }
                        Button {
                            overrideScheme = .light
                            appearanceOverrideRawValue = "light"
                        } label: {
                            Label("Light", systemImage: overrideScheme == .light ? "checkmark" : "")
                        }
                        Button {
                            overrideScheme = .dark
                            appearanceOverrideRawValue = "dark"
                        } label: {
                            Label("Dark", systemImage: overrideScheme == .dark ? "checkmark" : "")
                        }
                    } label: {
                        Image(systemName: iconForScheme())
                    }
                    .accessibilityLabel(Text("appearance_menu"))
                }
            }
            .listStyle(.sidebar)
        } detail: {
            detailView()
                .padding(hSizeClass == .compact ? 8 : 20)
                .animation(.default, value: hSizeClass)
        }
        .background(Color(uiColor: .systemBackground))
        .preferredColorScheme(overrideScheme)
        .onAppear {
            switch appearanceOverrideRawValue {
            case "light":
                overrideScheme = .light
            case "dark":
                overrideScheme = .dark
            default:
                overrideScheme = nil
            }
            loadData()
            // Ensure detail is visible on launch when a selection exists (especially on iPhone)
            #if os(iOS)
            if selectedGroup != nil {
                columnVisibility = .all
            }
            #endif
        }
        .onChange(of: taskGroups) { _, newValue in
            Persistence.saveTaskGroups(newValue)
        }
        .onChange(of: selectedGroup) { _, newValue in
            storedSelectedGroupID = newValue?.id.uuidString
            #if os(iOS)
            withAnimation {
                columnVisibility = (newValue == nil) ? .automatic : .all
            }
            #endif
        }
        .navigationSplitViewStyle(.balanced)
        .alert("New Group", isPresented: $isPresentingNewGroupPrompt) {
            TextField("Group name", text: $newGroupTitle)
            Button("Create") {
                let title = newGroupTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                createGroup(with: title.isEmpty ? "New Group" : title)
                newGroupTitle = ""
            }
            Button("Cancel", role: .cancel) {
                newGroupTitle = ""
            }
        }
    }

    @ViewBuilder
    private func detailView() -> some View {
        if let group = selectedGroup, let index = taskGroups.firstIndex(where: { $0.id == group.id }) {
            TaskGroupDetailView(groups: $taskGroups[index])
                .navigationTitle(Text(group.title))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Rename") {
                            renameTitle = taskGroups[index].title
                            isPresentingRenamePrompt = true
                        }
                    }
                }
                .alert("Rename Group", isPresented: $isPresentingRenamePrompt) {
                    TextField("Group name", text: $renameTitle)
                    Button("Save") {
                        let title = renameTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !title.isEmpty {
                            taskGroups[index].title = title
                            Persistence.saveTaskGroups(taskGroups)
                        }
                        renameTitle = ""
                    }
                    Button("Cancel", role: .cancel) {
                        renameTitle = ""
                    }
                }
        } else {
            VStack(spacing: 16) {
                ContentUnavailableView(
                    "select_group_title",
                    systemImage: "sidebar.left",
                    description: Text("select_group_message")
                )
                Button(action: { isPresentingNewGroupPrompt = true }) {
                    Label {
                        Text("add_group")
                    } icon: {
                        Image(systemName: "plus")
                    }
                    .font(.headline)
                }
                .buttonStyle(.borderedProminent)
            }
            .accessibilityElement(children: .contain)
            .multilineTextAlignment(.center)
            .padding()
        }
    }

    private func toggleSidebar() {
        #if os(iOS)
        withAnimation {
            switch columnVisibility {
            case .detailOnly:
                columnVisibility = .all
            default:
                columnVisibility = .detailOnly
            }
        }
        #endif
    }

    private func createGroup(with title: String) {
        withAnimation {
            let new = TaskGroup(title: title, symbolName: "folder.fill", tasks: [])
            taskGroups.append(new)
            selectedGroup = new
            Persistence.saveTaskGroups(taskGroups)
        }
    }

    private func deleteGroups(at offsets: IndexSet) {
        // Determine if the current selected group will be deleted
        let deletingSelected: Bool = {
            guard let sel = selectedGroup, let selIndex = taskGroups.firstIndex(where: { $0.id == sel.id }) else { return false }
            return offsets.contains(selIndex)
        }()

        taskGroups.remove(atOffsets: offsets)

        if deletingSelected {
            // Clear stored selection if it pointed to the deleted group
            storedSelectedGroupID = nil
            selectedGroup = taskGroups.first
        } else if let current = selectedGroup, !taskGroups.contains(where: { $0.id == current.id }) {
            // Safety: if selection somehow became invalid, reset it
            storedSelectedGroupID = nil
            selectedGroup = taskGroups.first
        }
        Persistence.saveTaskGroups(taskGroups)
    }
    
    private func iconForScheme() -> String {
        switch overrideScheme {
        case .some(.light):
            return "sun.max"
        case .some(.dark):
            return "moon"
        default:
            return "circle.lefthalf.filled"
        }
    }
    
    private func loadData() {
        // Prefer saved data
        if let loaded = Persistence.loadTaskGroups(), !loaded.isEmpty {
            taskGroups = loaded
        }

        // Restore selection from storage if possible; otherwise pick first
        if let idString = storedSelectedGroupID, let uuid = UUID(uuidString: idString),
           let match = taskGroups.first(where: { $0.id == uuid }) {
            selectedGroup = match
        } else {
            storedSelectedGroupID = nil
            selectedGroup = taskGroups.first
        }
    }
    
}
