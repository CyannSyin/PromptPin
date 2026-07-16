# PromptPin Architecture

PromptPin is a native macOS menu bar app for organizing reusable prompts as ordered project workflows.

## Product model

```text
PromptPin
└── Project
    ├── SOP step / Prompt 1
    ├── SOP step / Prompt 2
    └── SOP step / Prompt 3
```

The menu bar experience is optimized for retrieval: select a project, select a workflow step, and copy its prompt. Editing happens in a separate management window.

## Code structure

```text
Sources/PromptPin/
├── App/
│   └── PromptPinApp.swift          App scenes and menu bar entry point
├── Models/
│   ├── PromptProject.swift         Project and ordered prompt collection
│   └── PromptItem.swift            SOP step title and prompt content
├── Services/
│   ├── PromptStore.swift           State, CRUD, ordering, JSON persistence
│   └── ClipboardService.swift      macOS pasteboard integration
└── Views/
    ├── MenuBar/
    │   ├── MenuBarRootView.swift   Searchable project list
    │   └── PromptListView.swift    Ordered prompts and one-click copy
    └── Manager/
        ├── ManagerView.swift       Project/prompt management
        └── EditorSheets.swift      Project and prompt editors
```

## State and persistence

`PromptStore` is the single source of truth. Views call its mutation methods, and every successful mutation is written atomically to:

```text
~/Library/Application Support/PromptPin/prompts.json
```

JSON keeps the MVP dependency-free and makes future import/export straightforward. A database can replace the persistence layer later without changing the product model or view hierarchy.

## MVP boundaries

Included:

- Local projects
- Ordered SOP prompts
- Project search
- One-click copy
- Create, edit, delete, and reorder
- Local persistence

Deferred:

- Accounts and cloud sync
- Team collaboration
- Prompt variables
- Import/export UI
- Usage analytics and version history
