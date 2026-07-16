<p align="center">
  <img src="Assets/PromptPinIcon.png" width="144" alt="PromptPin logo">
</p>

<h1 align="center">PromptPin</h1>

<p align="center"><strong>Your prompts, one click away.</strong></p>

PromptPin is a lightweight macOS menu bar app that organizes reusable prompts for any project or repeatable workflow. Use it for development, research, writing, operations, or any process where useful prompts should stay ordered and close at hand.

## MVP

- Select a project from the menu bar
- View its prompts in your preferred order
- Copy a prompt with one click
- Create, edit, delete, and reorder projects and prompts
- See the selected project name and prompt count in Manage
- Keep all data locally on your Mac

## Requirements

- macOS 14 or later
- Xcode with the matching macOS SDK

## Run

1. Open `Package.swift` in Xcode.
2. Select the `PromptPin` scheme and **My Mac** destination.
3. Press **Run**.
4. Find the pin-and-prompt icon in the macOS menu bar.

Use **Manage** at the bottom of the menu to edit projects and prompts. Select a project in the sidebar, then use **Add Prompt** in the detail header to add a step.

Prompt data is stored at:

```text
~/Library/Application Support/PromptPin/prompts.json
```

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for the product model, source layout, and MVP boundaries.

## Design assets

- [`Assets/PromptPinIcon.svg`](Assets/PromptPinIcon.svg) and [`Assets/PromptPinIcon.png`](Assets/PromptPinIcon.png): editable and raster product icon
- [`Assets/PromptPinMenuBarIcon.svg`](Assets/PromptPinMenuBarIcon.svg) and [`Assets/PromptPinMenuBarIcon.png`](Assets/PromptPinMenuBarIcon.png): menu bar icon source and Retina PNG
- [`Sources/PromptPin/Resources/PromptPinMenuBarIcon.png`](Sources/PromptPin/Resources/PromptPinMenuBarIcon.png): packaged runtime resource

The menu bar artwork is loaded as a macOS template image. macOS automatically applies the correct color for light, dark, and selected menu bar states.

## Development

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test
```

The command-line Swift compiler and macOS SDK must come from the same Xcode installation. If Xcode is installed somewhere else, update `DEVELOPER_DIR` accordingly.
