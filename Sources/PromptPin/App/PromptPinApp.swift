import AppKit
import SwiftUI

@main
@MainActor
struct PromptPinApp: App {
    @StateObject private var store = PromptStore()

    private let menuBarIcon: NSImage = {
        let resourceURL = Bundle.main.url(
            forResource: "PromptPinMenuBarIcon",
            withExtension: "png"
        ) ?? Bundle.module.url(
            forResource: "PromptPinMenuBarIcon",
            withExtension: "png"
        )

        guard let resourceURL, let image = NSImage(contentsOf: resourceURL) else {
            return NSImage(systemSymbolName: "pin.fill", accessibilityDescription: "PromptPin")!
        }

        image.size = NSSize(width: 18, height: 18)
        image.isTemplate = true
        return image
    }()

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        MenuBarExtra {
            MenuBarRootView()
                .environmentObject(store)
        } label: {
            Image(nsImage: menuBarIcon)
                .renderingMode(.template)
                .accessibilityLabel("PromptPin")
        }
        .menuBarExtraStyle(.window)

        Settings {
            ManagerView()
                .environmentObject(store)
                .frame(minWidth: 820, minHeight: 560)
        }
    }
}
