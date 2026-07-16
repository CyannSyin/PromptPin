# PromptPin

Your prompts, one click away.

PromptPin is a lightweight macOS menu bar app that organizes reusable prompts by project and workflow.

## MVP

- Select a project from the menu bar
- View its prompts in SOP order
- Copy a prompt with one click
- Create, edit, delete, and reorder projects and prompts
- Keep all data locally on your Mac

## Requirements

- macOS 14 or later
- Xcode with the matching macOS SDK

## Run

1. Open `Package.swift` in Xcode.
2. Select the `PromptPin` scheme and **My Mac** destination.
3. Press **Run**.
4. Find the pin icon in the macOS menu bar.

Use **Manage** at the bottom of the menu to edit projects and workflow prompts.

Prompt data is stored at:

```text
~/Library/Application Support/PromptPin/prompts.json
```

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for the product model, source layout, and MVP boundaries.

## Development

```sh
swift test
```

The command-line Swift compiler and macOS SDK must come from the same Xcode installation.
