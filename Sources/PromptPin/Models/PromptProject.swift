import Foundation

struct PromptProject: Identifiable, Codable, Equatable, Sendable {
    var id: UUID
    var name: String
    var symbol: String
    var prompts: [PromptItem]
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        symbol: String = "folder",
        prompts: [PromptItem] = [],
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.prompts = prompts
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
