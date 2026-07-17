<p align="center">
  <img src="Assets/PromptPinIcon.png" width="144" alt="PromptPin logo">
</p>

<h1 align="center">PromptPin</h1>

<p align="center"><strong>Your prompts, one click away.</strong></p>
<p align="center">Version 0.1.2 · macOS 14+</p>

PromptPin is a lightweight macOS menu bar app that organizes reusable prompts for any project or repeatable workflow. Use it for development, research, writing, operations, or any process where useful prompts should stay ordered and close at hand.

## MVP

- Select a project from the menu bar
- View its prompts in your preferred order
- Copy a prompt with one click
- Create, edit, delete, and reorder projects and prompts
- See the selected project name and prompt count in Manage
- Keep all data locally on your Mac

## Requirements

- Using the app: macOS 14 or later
- Developing from source: Xcode with the matching macOS SDK

## Install with DMG

If you only want to use PromptPin, download `PromptPin-0.1.2.dmg`, open it, and drag **PromptPin** into the **Applications** folder. You do not need Xcode or the source code.

> **Note:** The current DMG is ad hoc signed for local testing and has not been notarized by Apple.

## Current release

| Version | Build | Released | Minimum macOS | Package |
| --- | ---: | --- | --- | --- |
| 0.1.2 | 3 | 2026-07-17 | macOS 14.0 | `PromptPin-0.1.2.dmg` |

## Release history

### 0.1.2 — 2026-07-17

- Fixed a crash when opening the menu popover from a DMG installation on another Mac.
- Made release builds load the menu bar artwork only from the installed app bundle, with a system icon fallback.
- Added the rebuilt `PromptPin-0.1.2.dmg` package.

### 0.1.1 — 2026-07-17

- Refined the menu bar popover header with the PromptPin icon and hover tooltip.
- Redesigned the Manage window with a compact title bar and improved sidebar controls.
- Moved project information and prompt actions upward to use space more efficiently.
- Ensured the Manage window opens in front of other windows.
- Improved empty-project and empty-prompt layouts.
- Added the refreshed `PromptPin-0.1.1.dmg` package.

### 0.1.0 — 2026-07-16

- Released the initial macOS menu bar MVP.
- Added local project and prompt creation, editing, deletion, and ordering.
- Added one-click prompt copying and local JSON persistence.
- Added the first ad hoc signed DMG package.

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

Build the app bundle and DMG with:

```sh
./scripts/package-dmg.sh
```

The generated image is written to `dist/PromptPin-0.1.2.dmg`.
