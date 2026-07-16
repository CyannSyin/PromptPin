import Combine
import Foundation

@MainActor
final class PromptStore: ObservableObject {
    @Published private(set) var projects: [PromptProject] = []

    private let fileURL: URL
    private let fileManager: FileManager

    init(
        fileURL: URL? = nil,
        fileManager: FileManager = .default,
        seedWhenEmpty: Bool = true
    ) {
        self.fileManager = fileManager
        self.fileURL = fileURL ?? Self.defaultFileURL(fileManager: fileManager)
        load(seedWhenEmpty: seedWhenEmpty)
    }

    func project(id: UUID) -> PromptProject? {
        projects.first { $0.id == id }
    }

    @discardableResult
    func addProject(name: String, symbol: String = "folder") -> UUID {
        let project = PromptProject(name: name.trimmedOr("Untitled Project"), symbol: symbol)
        projects.append(project)
        persist()
        return project.id
    }

    func updateProject(id: UUID, name: String, symbol: String) {
        guard let index = projectIndex(id) else { return }
        projects[index].name = name.trimmedOr("Untitled Project")
        projects[index].symbol = symbol
        projects[index].updatedAt = .now
        persist()
    }

    func deleteProject(id: UUID) {
        projects.removeAll { $0.id == id }
        persist()
    }

    @discardableResult
    func addPrompt(projectID: UUID, title: String, content: String) -> UUID? {
        guard let index = projectIndex(projectID) else { return nil }
        let prompt = PromptItem(
            title: title.trimmedOr("Untitled Prompt"),
            content: content.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        projects[index].prompts.append(prompt)
        projects[index].updatedAt = .now
        persist()
        return prompt.id
    }

    func updatePrompt(projectID: UUID, promptID: UUID, title: String, content: String) {
        guard
            let projectIndex = projectIndex(projectID),
            let promptIndex = projects[projectIndex].prompts.firstIndex(where: { $0.id == promptID })
        else { return }

        projects[projectIndex].prompts[promptIndex].title = title.trimmedOr("Untitled Prompt")
        projects[projectIndex].prompts[promptIndex].content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        projects[projectIndex].prompts[promptIndex].updatedAt = .now
        projects[projectIndex].updatedAt = .now
        persist()
    }

    func deletePrompt(projectID: UUID, promptID: UUID) {
        guard let index = projectIndex(projectID) else { return }
        projects[index].prompts.removeAll { $0.id == promptID }
        projects[index].updatedAt = .now
        persist()
    }

    func movePrompt(projectID: UUID, promptID: UUID, direction: MoveDirection) {
        guard
            let projectIndex = projectIndex(projectID),
            let promptIndex = projects[projectIndex].prompts.firstIndex(where: { $0.id == promptID })
        else { return }

        let destination: Int
        switch direction {
        case .up:
            destination = promptIndex - 1
        case .down:
            destination = promptIndex + 1
        }

        guard projects[projectIndex].prompts.indices.contains(destination) else { return }
        projects[projectIndex].prompts.swapAt(promptIndex, destination)
        projects[projectIndex].updatedAt = .now
        persist()
    }

    enum MoveDirection {
        case up
        case down
    }

    private func projectIndex(_ id: UUID) -> Int? {
        projects.firstIndex { $0.id == id }
    }

    private func load(seedWhenEmpty: Bool) {
        do {
            let data = try Data(contentsOf: fileURL)
            projects = try JSONDecoder.promptPin.decode([PromptProject].self, from: data)
        } catch {
            projects = seedWhenEmpty ? Self.sampleProjects : []
            if seedWhenEmpty {
                persist()
            }
        }
    }

    private func persist() {
        do {
            try fileManager.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            let data = try JSONEncoder.promptPin.encode(projects)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            assertionFailure("Failed to save PromptPin data: \(error)")
        }
    }

    private static func defaultFileURL(fileManager: FileManager) -> URL {
        let applicationSupport = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first!
        return applicationSupport
            .appendingPathComponent("PromptPin", isDirectory: true)
            .appendingPathComponent("prompts.json")
    }

    private static var sampleProjects: [PromptProject] {
        [
            PromptProject(
                name: "Product Development",
                symbol: "hammer",
                prompts: [
                    PromptItem(
                        title: "1. Clarify requirements",
                        content: "Review the following requirement. Identify ambiguities, missing constraints, edge cases, and questions that should be answered before implementation:\n\n"
                    ),
                    PromptItem(
                        title: "2. Create technical plan",
                        content: "Create an implementation plan for the following requirement. Include architecture, data flow, key decisions, risks, tests, and a clear task breakdown:\n\n"
                    ),
                    PromptItem(
                        title: "3. Review implementation",
                        content: "Review the following implementation for correctness, maintainability, security, performance, and missing test coverage:\n\n"
                    )
                ]
            )
        ]
    }
}

private extension String {
    func trimmedOr(_ fallback: String) -> String {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? fallback : trimmed
    }
}

private extension JSONEncoder {
    static var promptPin: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

private extension JSONDecoder {
    static var promptPin: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
