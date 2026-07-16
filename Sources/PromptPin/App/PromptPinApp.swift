import AppKit
import SwiftUI

@main
@MainActor
struct PromptPinApp: App {
    @StateObject private var store = PromptStore()

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        MenuBarExtra("PromptPin", systemImage: "pin.fill") {
            MenuBarRootView()
                .environmentObject(store)
        }
        .menuBarExtraStyle(.window)

        Settings {
            ManagerView()
                .environmentObject(store)
                .frame(minWidth: 820, minHeight: 560)
        }
    }
}
