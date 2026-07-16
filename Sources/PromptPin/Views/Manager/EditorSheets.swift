import SwiftUI

enum ProjectEditorTarget: Identifiable {
    case new
    case edit(PromptProject)

    var id: String {
        switch self {
        case .new: "new-project"
        case .edit(let project): project.id.uuidString
        }
    }
}

struct ProjectEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    let target: ProjectEditorTarget
    let onSave: (String, String) -> Void

    @State private var name: String
    @State private var symbol: String

    private let symbols = ["folder", "hammer", "shippingbox", "app", "globe", "briefcase", "terminal", "sparkles"]

    init(target: ProjectEditorTarget, onSave: @escaping (String, String) -> Void) {
        self.target = target
        self.onSave = onSave
        switch target {
        case .new:
            _name = State(initialValue: "")
            _symbol = State(initialValue: "folder")
        case .edit(let project):
            _name = State(initialValue: project.name)
            _symbol = State(initialValue: project.symbol)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(isNew ? "New Project" : "Edit Project")
                .font(.title2.bold())

            TextField("Project name", text: $name)
                .textFieldStyle(.roundedBorder)

            VStack(alignment: .leading, spacing: 8) {
                Text("Icon")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack {
                    ForEach(symbols, id: \.self) { candidate in
                        Button {
                            symbol = candidate
                        } label: {
                            Image(systemName: candidate)
                                .frame(width: 24, height: 24)
                                .padding(4)
                                .background(symbol == candidate ? Color.accentColor.opacity(0.18) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            HStack {
                Spacer()
                Button("Cancel", role: .cancel) { dismiss() }
                Button("Save") {
                    onSave(name, symbol)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(24)
        .frame(width: 430)
    }

    private var isNew: Bool {
        if case .new = target { return true }
        return false
    }
}

enum PromptEditorTarget: Identifiable {
    case new
    case edit(PromptItem)

    var id: String {
        switch self {
        case .new: "new-prompt"
        case .edit(let prompt): prompt.id.uuidString
        }
    }
}

struct PromptEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    let target: PromptEditorTarget
    let onSave: (String, String) -> Void

    @State private var title: String
    @State private var content: String

    init(target: PromptEditorTarget, onSave: @escaping (String, String) -> Void) {
        self.target = target
        self.onSave = onSave
        switch target {
        case .new:
            _title = State(initialValue: "")
            _content = State(initialValue: "")
        case .edit(let prompt):
            _title = State(initialValue: prompt.title)
            _content = State(initialValue: prompt.content)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(isNew ? "New Prompt" : "Edit Prompt")
                .font(.title2.bold())

            TextField("SOP step title", text: $title)
                .textFieldStyle(.roundedBorder)

            TextEditor(text: $content)
                .font(.body.monospaced())
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
                .frame(minHeight: 250)

            HStack {
                Text("This text is copied when you click the prompt.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Cancel", role: .cancel) { dismiss() }
                Button("Save") {
                    onSave(title, content)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(
                    title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                    content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )
            }
        }
        .padding(24)
        .frame(width: 600, height: 420)
    }

    private var isNew: Bool {
        if case .new = target { return true }
        return false
    }
}
