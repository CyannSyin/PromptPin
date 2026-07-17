import AppKit
import SwiftUI

enum PromptPinAssets {
    static let menuBarIcon: NSImage = {
        var resourceURL = Bundle.main.url(
            forResource: "PromptPinMenuBarIcon",
            withExtension: "png"
        )

        #if DEBUG
        if resourceURL == nil {
            resourceURL = Bundle.module.url(
                forResource: "PromptPinMenuBarIcon",
                withExtension: "png"
            )
        }
        #endif

        guard let resourceURL, let image = NSImage(contentsOf: resourceURL) else {
            return NSImage(systemSymbolName: "pin.fill", accessibilityDescription: "PromptPin")!
        }

        image.size = NSSize(width: 18, height: 18)
        image.isTemplate = true
        return image
    }()
}

@main
@MainActor
struct PromptPinApp: App {
    @StateObject private var store = PromptStore()

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        MenuBarExtra {
            MenuBarRootView()
                .environmentObject(store)
        } label: {
            Image(nsImage: PromptPinAssets.menuBarIcon)
                .renderingMode(.template)
                .accessibilityLabel("PromptPin")
                .help("PromptPin")
        }
        .menuBarExtraStyle(.window)

        Settings {
            ManagerView()
                .environmentObject(store)
                .frame(minWidth: 820, minHeight: 560)
        }
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle(showsTitle: true))
    }
}
