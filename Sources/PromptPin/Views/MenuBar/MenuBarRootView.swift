import AppKit
import SwiftUI

struct MenuBarRootView: View {
    @EnvironmentObject private var store: PromptStore
    @State private var searchText = ""

    private var filteredProjects: [PromptProject] {
        guard !searchText.isEmpty else { return store.projects }
        return store.projects.filter {
            $0.name.localizedStandardContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.projects.isEmpty {
                    ContentUnavailableView(
                        "No Projects",
                        systemImage: "folder.badge.plus",
                        description: Text("Create a project to organize your workflow prompts.")
                    )
                } else if filteredProjects.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List(filteredProjects) { project in
                        NavigationLink(value: project.id) {
                            ProjectRow(project: project)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("PromptPin")
            .searchable(text: $searchText, prompt: "Search projects")
            .navigationDestination(for: UUID.self) { projectID in
                PromptListView(projectID: projectID)
            }
            .safeAreaInset(edge: .bottom) {
                footer
            }
        }
        .frame(width: 380, height: 500)
    }

    private var footer: some View {
        HStack {
            SettingsLink {
                Label("Manage", systemImage: "slider.horizontal.3")
            }

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .buttonStyle(.borderless)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.regularMaterial)
    }
}

private struct ProjectRow: View {
    let project: PromptProject

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: project.symbol)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(project.name)
                    .font(.headline)
                Text("\(project.prompts.count) prompts")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 5)
    }
}
