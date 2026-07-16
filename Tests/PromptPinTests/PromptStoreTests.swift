import Foundation
import Testing
@testable import PromptPin

@MainActor
struct PromptStoreTests {
    @Test
    func projectAndPromptLifecyclePersists() throws {
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent("prompts.json")

        let store = PromptStore(fileURL: fileURL, seedWhenEmpty: false)
        let projectID = store.addProject(name: "Website", symbol: "globe")
        let promptID = try #require(store.addPrompt(
            projectID: projectID,
            title: "Plan",
            content: "Create a plan"
        ))

        store.updatePrompt(
            projectID: projectID,
            promptID: promptID,
            title: "Technical plan",
            content: "Create a technical plan"
        )

        let reloaded = PromptStore(fileURL: fileURL, seedWhenEmpty: false)
        let project = try #require(reloaded.project(id: projectID))
        #expect(project.name == "Website")
        #expect(project.prompts.first?.title == "Technical plan")
        #expect(project.prompts.first?.content == "Create a technical plan")
    }

    @Test
    func promptsCanBeReordered() throws {
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent("prompts.json")
        let store = PromptStore(fileURL: fileURL, seedWhenEmpty: false)
        let projectID = store.addProject(name: "Workflow")
        let firstID = try #require(store.addPrompt(projectID: projectID, title: "First", content: "1"))
        let secondID = try #require(store.addPrompt(projectID: projectID, title: "Second", content: "2"))

        store.movePrompt(projectID: projectID, promptID: secondID, direction: .up)

        let project = try #require(store.project(id: projectID))
        #expect(project.prompts.map(\.id) == [secondID, firstID])
    }
}
