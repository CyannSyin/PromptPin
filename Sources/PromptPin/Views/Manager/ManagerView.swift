import SwiftUI

struct ManagerView: View {
    @EnvironmentObject private var store: PromptStore
    @State private var selectedProjectID: UUID?
    @State private var projectEditor: ProjectEditorTarget?

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedProjectID) {
                ForEach(store.projects) { project in
                    Label(project.name, systemImage: project.symbol)
                        .tag(project.id)
                        .contextMenu {
                            Button("Edit") {
                                projectEditor = .edit(project)
                            }
                            Divider()
                            Button("Delete", role: .destructive) {
                                deleteProject(project.id)
                            }
                        }
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem {
                    Button {
                        projectEditor = .new
                    } label: {
                        Label("New Project", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if let selectedProjectID, store.project(id: selectedProjectID) != nil {
                ProjectManagerView(projectID: selectedProjectID)
            } else {
                ContentUnavailableView(
                    "Select a Project",
                    systemImage: "folder",
                    description: Text("Choose a project or create a new one.")
                )
            }
        }
        .onAppear {
            if selectedProjectID == nil {
                selectedProjectID = store.projects.first?.id
            }
        }
        .sheet(item: $projectEditor) { target in
            ProjectEditorSheet(target: target) { name, symbol in
                switch target {
                case .new:
                    selectedProjectID = store.addProject(name: name, symbol: symbol)
                case .edit(let project):
                    store.updateProject(id: project.id, name: name, symbol: symbol)
                }
            }
        }
    }

    private func deleteProject(_ id: UUID) {
        store.deleteProject(id: id)
        if selectedProjectID == id {
            selectedProjectID = store.projects.first?.id
        }
    }
}

private struct ProjectManagerView: View {
    @EnvironmentObject private var store: PromptStore
    let projectID: UUID

    @State private var promptEditor: PromptEditorTarget?

    private var project: PromptProject? {
        store.project(id: projectID)
    }

    var body: some View {
        Group {
            if let project {
                VStack(spacing: 0) {
                    ProjectPromptHeader(
                        project: project,
                        onAddPrompt: { promptEditor = .new }
                    )

                    Divider()

                    if project.prompts.isEmpty {
                        ContentUnavailableView(
                            "No Prompts",
                            systemImage: "text.badge.plus",
                            description: Text("Add the first prompt for this project.")
                        )
                    } else {
                        List {
                            ForEach(Array(project.prompts.enumerated()), id: \.element.id) { index, prompt in
                                PromptManagerRow(
                                    prompt: prompt,
                                    position: index + 1,
                                    isFirst: index == 0,
                                    isLast: index == project.prompts.count - 1,
                                    onEdit: { promptEditor = .edit(prompt) },
                                    onMoveUp: { store.movePrompt(projectID: projectID, promptID: prompt.id, direction: .up) },
                                    onMoveDown: { store.movePrompt(projectID: projectID, promptID: prompt.id, direction: .down) },
                                    onDelete: { store.deletePrompt(projectID: projectID, promptID: prompt.id) }
                                )
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Prompts")
        .sheet(item: $promptEditor) { target in
            PromptEditorSheet(target: target) { title, content in
                switch target {
                case .new:
                    store.addPrompt(projectID: projectID, title: title, content: content)
                case .edit(let prompt):
                    store.updatePrompt(
                        projectID: projectID,
                        promptID: prompt.id,
                        title: title,
                        content: content
                    )
                }
            }
        }
    }
}

private struct ProjectPromptHeader: View {
    let project: PromptProject
    let onAddPrompt: () -> Void
    @State private var isAddPromptHovered = false

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(project.name)
                    .font(.title2.bold())
                    .lineLimit(1)

                Text(promptCountDescription)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onAddPrompt) {
                Label("Add Prompt", systemImage: "plus")
                    .font(.body.weight(.medium))
                    .foregroundStyle(isAddPromptHovered ? Color.accentColor : Color.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(
                        isAddPromptHovered ? Color.accentColor.opacity(0.12) : Color.clear,
                        in: RoundedRectangle(cornerRadius: 8)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .onHover { isHovered in
                withAnimation(.easeOut(duration: 0.15)) {
                    isAddPromptHovered = isHovered
                }
            }
            .help("Add a prompt to \(project.name)")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private var promptCountDescription: String {
        let count = project.prompts.count
        return "\(count) \(count == 1 ? "prompt" : "prompts")"
    }
}

private struct PromptManagerRow: View {
    let prompt: PromptItem
    let position: Int
    let isFirst: Bool
    let isLast: Bool
    let onEdit: () -> Void
    let onMoveUp: () -> Void
    let onMoveDown: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(position)")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .frame(width: 24, height: 24)
                .background(.quaternary, in: Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text(prompt.title)
                    .font(.headline)
                Text(prompt.content)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }

            Spacer()

            HStack(spacing: 4) {
                Button(action: onMoveUp) {
                    Image(systemName: "arrow.up")
                }
                .disabled(isFirst)
                .help("Move up")

                Button(action: onMoveDown) {
                    Image(systemName: "arrow.down")
                }
                .disabled(isLast)
                .help("Move down")

                Button(action: onEdit) {
                    Image(systemName: "pencil")
                }
                .help("Edit")

                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                }
                .help("Delete")
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 6)
    }
}
