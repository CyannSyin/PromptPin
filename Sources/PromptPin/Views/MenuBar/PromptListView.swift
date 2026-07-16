import SwiftUI

struct PromptListView: View {
    @EnvironmentObject private var store: PromptStore
    let projectID: UUID

    @State private var copiedPromptID: UUID?

    private var project: PromptProject? {
        store.project(id: projectID)
    }

    var body: some View {
        Group {
            if let project {
                if project.prompts.isEmpty {
                    ContentUnavailableView(
                        "No Prompts",
                        systemImage: "text.badge.plus",
                        description: Text("Add prompts for this project in Manage.")
                    )
                } else {
                    List {
                        ForEach(Array(project.prompts.enumerated()), id: \.element.id) { index, prompt in
                            Button {
                                copy(prompt)
                            } label: {
                                promptRow(prompt, step: index + 1)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listStyle(.plain)
                }
            } else {
                ContentUnavailableView("Project Not Found", systemImage: "questionmark.folder")
            }
        }
        .navigationTitle(project?.name ?? "Prompts")
    }

    private func promptRow(_ prompt: PromptItem, step: Int) -> some View {
        HStack(spacing: 12) {
            Text("\(step)")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .frame(width: 24, height: 24)
                .background(.quaternary, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(prompt.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(prompt.content)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            Image(systemName: copiedPromptID == prompt.id ? "checkmark.circle.fill" : "doc.on.doc")
                .foregroundStyle(copiedPromptID == prompt.id ? Color.green : Color.secondary)
                .contentTransition(.symbolEffect(.replace))
        }
        .contentShape(Rectangle())
        .padding(.vertical, 6)
    }

    private func copy(_ prompt: PromptItem) {
        ClipboardService.copy(prompt.content)
        withAnimation {
            copiedPromptID = prompt.id
        }

        Task {
            try? await Task.sleep(for: .seconds(1.2))
            guard copiedPromptID == prompt.id else { return }
            withAnimation {
                copiedPromptID = nil
            }
        }
    }
}
