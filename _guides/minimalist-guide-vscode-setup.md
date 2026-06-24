---
layout: page
title: "The Minimalist's Guide to VSCode Setup"
order: 5
date: 2026-06-24
---

# The Minimalist's Guide to VS Code Setup

{% assign words = page.content | number_of_words %}
**Prahlad Yeri** · June 24, 2026 · {% if words < 360 %}1 min{% else %}{{ words | divided_by: 180 }} min{% endif %} read

*A guide for the power-user who values control, clarity, and a lean editor over feature bloat.*

## Table of Contents
- [1. Introduction: The Minimalist Editor Philosophy](#1-introduction-the-minimalist-editor-philosophy)
- [2. Installation with Full Manual Control](#2-installation-with-full-manual-control)
- [3. Configuration Fundamentals](#3-configuration-fundamentals)
- [4. Notepad++ Muscle-Memory Migration](#4-notepad-muscle-memory-migration)
- [5. Built-in Power Features (Use Before Installing Anything)](#5-built-in-power-features-use-before-installing-anything)
- [6. Keyboard Shortcuts & Keybinding Philosophy](#6-keyboard-shortcuts--keybinding-philosophy)
- [7. HTML / CSS / JavaScript for React Development](#7-html--css-javascript-for-react-development)
- [8. Python Development](#8-python-development)
- [9. PHP Development](#9-php-development)
- [10. C# Projects and Solutions (.NET Core & .NET Framework)](#10-c-projects-and-solutions-net-core--net-framework)
- [11. Extension Discipline: The Anti-Bloat Protocol](#11-extension-discipline-the-anti-bloat-protocol)
- [12. Backup, Portability, and Sync (Without Microsoft Accounts)](#12-backup-portability-and-sync-without-microsoft-accounts)
- [13. Performance Tuning & Troubleshooting](#13-performance-tuning--troubleshooting)
- [14. Appendices](#14-appendices)

---

## 1. Introduction: The Minimalist Editor Philosophy

### 1.1 Why VS Code (and not Vim, Sublime, or staying on Notepad++)
Notepad++ is a legendary text editor, but it lacks native LSP (Language Server Protocol) support, modern multi-cursor ergonomics, and integrated terminal profiling. Vim requires a steep cognitive load for configuration. Sublime is proprietary and its package ecosystem is fracturing. VS Code sits in the sweet spot: it is fundamentally a text editor with a standardized extension API, allowing you to build *exactly* the IDE you need, and nothing more.

### 1.2 The "default-first" rule: exhaust built-ins before installing anything
VS Code ships with a massive amount of hidden functionality. Before installing an extension to "add a feature," check if it already exists. The minimalist rule: **If a built-in feature can do 80% of what you need, use it.** Do not install a "Live Server" extension when a simple terminal alias or built-in preview works. Do not install "GitLens" when the built-in Source Control gutter decorations suffice.

### 1.3 Notepad++ → VS Code mindset translation
- **Sessions** become **Workspaces** (`.code-workspace`).
- **Macros** become **Snippets** and **Multi-cursors**.
- **Plugin Manager** becomes the **CLI** (`code --install-extension`) and `.vscode/extensions.json`.
- **Document Map** becomes the **Minimap** (or is disabled entirely).

### 1.4 What this guide will *not* cover
- **Copilot / AI Tab-completers**: They introduce latency, telemetry, and cognitive clutter. You are a power user; you write the code.
- **Theme and Icon Packs**: Material icons and Dracula themes are visual noise. We use the default Dark+ or a high-contrast minimalist theme.
- **"Productivity" Suites**: No pomodoro timers, no distraction-free "zen" modes that hide the file explorer. 

---

## 2. Installation with Full Manual Control

### 2.1 Choosing the install method
Avoid the `.exe` or `.msi` system installers if you want total control. They pollute the registry and scatter config across `%APPDATA%`. 
- **Windows**: Use `winget install Microsoft.VisualStudioCode --source winget` or download the `.zip` system archive.
- **macOS**: `brew install --cask visual-studio-code`.
- **Linux**: `apt` or `dnf` repositories.

### 2.2 Portable Mode — the minimalist's best friend
Portable mode keeps VS Code entirely self-contained. No registry keys, no `%APPDATA%` pollution. It can be run from a USB drive or a synced folder.
1. Download the `.zip` (Windows) or `.tar.gz` (Linux) archive.
2. Extract it to `C:\Tools\VSCode` (or equivalent).
3. Inside the extracted root, create a folder named `data`.
4. Launch `Code.exe`. VS Code will now store all settings, extensions, and logs inside `data/`.

### 2.3 Directory layout
In Portable Mode (or standard install), understand your directories:
- `data/user-data/`: Your `settings.json` and `keybindings.json`.
- `data/extensions/`: The actual extension code.
- `data/logs/`: Crash and telemetry logs.

### 2.4 Disabling telemetry at install time
Create or edit `argv.json` (located in `data/` for portable, or `~/.vscode/` for standard). Add these flags to kill telemetry and optimize startup:

```json
{
  "disable-telemetry": true,
  "disable-workspace-trust": true,
  "enable-proposed-api": [],
  "locale": "en"
}
```

### 2.5 Verifying the install from the CLI
Ensure the `code` command is in your PATH. Verify with:
```bash
code --version
code --list-extensions # Should be empty on a fresh install
```

---

## 3. Configuration Fundamentals

### 3.1 `settings.json` vs. the Settings UI
The Settings UI is a crutch that hides the underlying JSON structure and makes bulk-editing impossible. Press `Ctrl+Shift+P`, type `Preferences: Open User Settings (JSON)`, and edit the raw file. 

### 3.2 Configuration scopes
Precedence flows downward. Understand this to avoid "why isn't my setting applying?"
1. **Default**: Built into VS Code.
2. **User**: `settings.json` (Global).
3. **Workspace**: `.vscode/settings.json` (Overrides User).
4. **Folder**: `.vscode/settings.json` in a multi-root workspace folder.

### 3.3 `keybindings.json` and `when`-clause contexts
Keybindings are scoped by context. You don't want `Ctrl+Enter` to run a script when your cursor is in the terminal. We use `when` clauses:
```json
{
  "key": "ctrl+enter",
  "command": "workbench.action.tasks.runTask",
  "when": "editorTextFocus && !terminalFocus"
}
```

### 3.4 Snippets
Snippets are faster than macros. Define them in `settings.json` under `editor.snippets` or in dedicated `.json` files via `Preferences: Configure User Snippets`. Scope them to languages to prevent bloat in the autocomplete menu.

### 3.5 Tasks and launch configurations
`tasks.json` automates CLI commands (build, lint). `launch.json` attaches the debugger. Keep these in `.vscode/` at the project root. They are code, not magic.

### 3.6 Managing profiles
Do not use one global profile. Create a "Web" profile (loads ESLint, Prettier) and a "Backend" profile (loads Python, PHP). 
*CLI:* `code --profile "Web" .`
This ensures extensions only activate when needed, saving RAM and CPU.

### 3.7 Version-controlling your config
Keep your `settings.json`, `keybindings.json`, and `snippets/` in a private Git repository. Symlink them into your VS Code user directory. This is the only sane way to manage config across machines without relying on Microsoft's Settings Sync.

---

## 4. Notepad++ Muscle-Memory Migration

### 4.1 Sessions → Workspaces
Notepad++ saves open tabs in a "Session". VS Code uses `.code-workspace` files.
Create `myproject.code-workspace`:
```json
{
  "folders": [
    { "path": "./frontend" },
    { "path": "./backend" }
  ],
  "settings": {
    "editor.fontSize": 14
  }
}
```
Open this file, and VS Code restores the exact folder structure and tab state.

### 4.2 Multi-selection, column select, and multi-cursor
N++ requires `Alt+Mouse Drag` for column edit. VS Code has this built-in, but the muscle memory needs updating:
- **Column Select**: `Shift+Alt+Mouse Drag` (or `Ctrl+Shift+Alt+Arrow Keys`).
- **Add Cursor**: `Alt+Click`.
- **Select Next Occurrence**: `Ctrl+D` (The most powerful multi-cursor tool in the editor).

### 4.3 Regex find/replace
N++ uses Boost regex. VS Code uses Rust-based regex. They are 95% identical. 
*Difference*: VS Code requires escaping forward slashes `/` in some contexts, and lookbehinds must be fixed-width. Use `Ctrl+H`, click the `.*` icon, and test.

### 4.4 Function List → Outline view
N++'s Function List is replaced by the **Outline** view (`Ctrl+Shift+O`). It is driven by the language server, meaning it understands classes, methods, and variables dynamically, not just via regex parsing.

### 4.5 Document Map → Minimap
N++'s Document Map is the **Minimap** on the right edge. 
*Minimalist tip*: It consumes GPU and screen real estate. Disable it globally in `settings.json`:
```json
"editor.minimap.enabled": false
```
Use `Ctrl+G` to jump to lines instead.

### 4.6 Compare plugin → built-in diff
N++ uses the "Compare" plugin. VS Code has native diffing.
CLI: `code --diff file1.js file2.js`
GUI: Select two files in Explorer, right-click -> "Compare Selected".

### 4.7 Macros → Snippets + multi-cursor
N++ macros record keystrokes. VS Code removed macro recording because multi-cursor and snippets solve the problem better. 
*Instead of recording a macro to wrap 10 lines in `<li>` tags:* Select the lines, `Shift+Alt+I` (adds cursor to end of each line), type `<li>`, `End`, type `</li>`.

### 4.8 Recommended keybinding remaps
To ease the transition, map N++ shortcuts in `keybindings.json`:
```json
// Map N++ "Run macro multiple times" (Ctrl+Shift+R) to VS Code "Add Selection to Next Find Match" (Ctrl+D)
{ "key": "ctrl+shift+r", "command": "editor.action.addSelectionToNextFindMatch" }
```

---

## 5. Built-in Power Features (Use Before Installing Anything)

### 5.1 Integrated Terminal
Do not use external terminals. VS Code's terminal supports profiles, split panes, and custom env vars.
```json
"terminal.integrated.profiles.windows": {
  "PowerShell Core": { "path": "pwsh.exe", "icon": "terminal-powershell" },
  "Git Bash": { "path": "bash.exe", "icon": "terminal-bash" }
}
```

### 5.2 Emmet
Built-in. No extension needed. Type `div.container>ul>li*5` and press `Tab`. It works in HTML, CSS, JSX, and Blade.

### 5.3 Command Palette and quick-open
- `Ctrl+P`: Go to File (fuzzy search).
- `Ctrl+Shift+P`: Command Palette.
- `Ctrl+P` then `:`: Go to Line.
- `Ctrl+P` then `@`: Go to Symbol in file.
- `Ctrl+P` then `@:`: Go to Symbol in workspace.

### 5.4 Navigation
- `F12` / `Ctrl+Click`: Go to Definition.
- `Shift+F12`: Find All References.
- `Ctrl+Tab`: Switch between recent files (like N++'s Document Switcher).

### 5.5 Refactor menu
`Ctrl+Shift+R` or `F2` (Rename Symbol). Built-in renaming updates all references across the workspace. Do not install "Refactor" extensions.

### 5.6 Source Control tab
The built-in Git integration handles staging, committing, pushing, and pulling. The gutter decorations (blue/green/red) show line changes. *Do not install GitLens* unless you specifically need historical blame annotations; it is a massive performance sink.

### 5.7 Problems panel, output, and debug console
- `Ctrl+Shift+M`: Problems panel (linting/errors).
- `Ctrl+Shift+U`: Output channel (task logs).
- `Ctrl+Shift+Y`: Debug console.

### 5.8 Snippets authoring
Create project-specific snippets in `.vscode/project.code-snippets`. This keeps boilerplate out of your global user settings.

### 5.9 Tasks
Run shell scripts, npm, make, or python without extensions. Define them in `.vscode/tasks.json`. (See Section 7/8/9/10 for examples).

### 5.10 Live Preview
For simple HTML, use the built-in "Simple Browser" (`Ctrl+Shift+P` -> `Simple Browser: Show`). For actual dev servers, run them in the terminal. Avoid "Live Server" extensions that spawn hidden background processes.

---

## 6. Keyboard Shortcuts & Keybinding Philosophy

### 6.1 Default cheat sheet
Learn the defaults before remapping. `Ctrl+K Ctrl+S` opens the keyboard shortcuts UI, but we edit JSON.

### 6.2 Editing `keybindings.json` by hand
`Ctrl+K Ctrl+Shift+K` opens the raw JSON. 

### 6.3 Using `when` clauses
Contexts are crucial. Examples:
- `editorTextFocus`: Cursor is in the code editor.
- `terminalFocus`: Cursor is in the terminal.
- `explorerViewletVisible`: File explorer is open.
- `inQuickOpen`: Command palette is open.

### 6.4 Resolving conflicts: `Remove` vs. override
If a shortcut conflicts, don't just override it. Remove the default binding first to prevent ghost triggers:
```json
{ "key": "ctrl+shift+p", "command": "-workbench.action.showCommands" }
```

### 6.5 Chorded shortcuts
Chords are two-part shortcuts (e.g., `Ctrl+K` followed by `Ctrl+C` to comment). Define them by separating keys with spaces:
```json
{ "key": "ctrl+k ctrl+m", "command": "editor.action.toggleMinimap" }
```

### 6.6 Recommended minimalist remaps
Keep it close to defaults. Only remap things that conflict with your OS or N++ muscle memory.

---

## 7. HTML / CSS / JavaScript for React Development

*Case Study: A 3-person agency building React frontends for headless WordPress CMSs. They need fast linting, zero bloat, and reliable debugging.*

### 7.1 What's already built-in
Emmet, JSX highlighting, basic IntelliSense, and CSS color decorators are native. 

### 7.2 Extension 1 — `dbaeumer.vscode-eslint`
**Justification**: Built-in JS validation only checks syntax. ESLint checks logic, React hooks rules, and team conventions. 
**Minimal config** (`.eslintrc.json`):
```json
{
  "extends": ["react-app", "react-app/jest"],
  "rules": { "no-unused-vars": "warn" }
}
```
Install per-project via `.vscode/extensions.json` so it doesn't bloat your global profile.

### 7.3 Extension 2 — `esbenp.prettier-vscode` (Optional)
**Justification**: Only install if the team enforces strict formatting. Otherwise, rely on ESLint `--fix`. If used, disable VS Code's default JS formatter:
```json
"[javascript]": { "editor.defaultFormatter": "esbenp.prettier-vscode" }
```

### 7.4 TypeScript config
Keep `tsconfig.json` strict. 
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "strict": true,
    "jsx": "react-jsx",
    "moduleResolution": "node"
  }
}
```

### 7.5 Running the React dev server via `tasks.json`
No extension needed. 
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Start React Dev Server",
      "type": "shell",
      "command": "npm start",
      "group": "build",
      "isBackground": true,
      "problemMatcher": []
    }
  ]
}
```

### 7.6 Debugging React in Chrome/Edge
Use the built-in `js-debug`. `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "chrome",
      "request": "launch",
      "name": "Debug React",
      "url": "http://localhost:3000",
      "webRoot": "${workspaceFolder}/src"
    }
  ]
}
```

### 7.7 CSS
Built-in validation is fine. Only add `csstools.postcss` if you are actively writing PostCSS plugins. Otherwise, standard CSS variables and nesting (now native) are sufficient.

### 7.8 Snippet library
Create `.vscode/react.code-snippets` for component boilerplate. Avoid global snippet packs that pollute autocomplete.

---

## 8. Python Development

*Case Study: A solo data engineer writing ETL scripts and FastAPI endpoints. Needs fast linting and reliable debugging without Anaconda's heavy IDE overhead.*

### 8.1 Extension 1 — `ms-python.python`
**Justification**: The one unavoidable extension. It provides the Python language server, environment management, and debugger integration. It is heavy, but necessary.

### 8.2 Interpreter selection
Never use the global system Python for projects. Use `venv`.
```json
"python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python"
```

### 8.3 Built-in debugger vs. `debugpy`
The Python extension uses `debugpy` under the hood. Configure it in `launch.json`:
```json
{
  "name": "Python: Current File",
  "type": "python",
  "request": "launch",
  "program": "${file}",
  "console": "integratedTerminal"
}
```

### 8.4 Linting: Choose ONE (Ruff)
**Do not install Pylint, Flake8, and Pyflakes.** Install `charliermarsh.ruff`. It is written in Rust, runs in milliseconds, and replaces all of them.
```json
"python.linting.enabled": true,
"python.linting.ruffEnabled": true,
"[python]": {
  "editor.codeActionsOnSave": { "source.organizeImports": "explicit" }
}
```

### 8.5 Formatting: Ruff formatter
Skip Black or Autopep8. Ruff includes a formatter.
```json
"[python]": {
  "editor.defaultFormatter": "charliermarsh.ruff",
  "editor.formatOnSave": true
}
```

### 8.6 Running scripts
**Do not install "Code Runner"**. It hides errors and manages processes poorly. Use the integrated terminal (`python ${file}`) or define a Task.

### 8.7 Jupyter notebooks
The built-in `.ipynb` renderer is sufficient for viewing. Only install `ms-toolsai.jupyter` if you need to execute cells and manage kernels directly inside the editor.

### 8.8 Type checking: mypy via task
Do not install a mypy extension. Run it via `tasks.json` or pre-commit hooks. It keeps the editor fast.

---

## 9. PHP Development

*Case Study: A freelancer maintaining 15 legacy WordPress sites and building custom Laravel APIs. Needs fast IntelliSense without the memory leak of older PHP extensions.*

### 9.1 Extension 1 — `bmewburn.vscode-intelephense-client`
**Justification**: The built-in PHP language server is basic and slow. Intelephense is blazing fast, handles large codebases (like WordPress core) without choking, and provides excellent go-to-definition.

### 9.2 Disabling the built-in PHP language server
To prevent conflicts and save RAM, disable the native PHP features:
```json
"php.validate.enable": false,
"php.suggest.basic": false
```

### 9.3 Executable paths
Point VS Code to your local PHP binary for Intelephense and validation:
```json
"php.validate.executablePath": "C:/php/php.exe",
"intelephense.environment.phpVersion": "8.2.0"
```

### 9.4 Composer integration via Tasks
**Do not install a Composer extension.** Use tasks:
```json
{
  "label": "Composer Install",
  "type": "shell",
  "command": "composer install",
  "options": { "cwd": "${workspaceFolder}" }
}
```

### 9.5 Running PHPUnit
Run it in the terminal: `./vendor/bin/phpunit`. Do not install heavy test-runner UI extensions. The terminal output is sufficient and faster.

### 9.6 Xdebug: `xdebug.php-debug`
**Justification**: The only second PHP extension you need. Felix Becker's debugger is the standard. 
Configure `launch.json`:
```json
{
  "name": "Listen for Xdebug",
  "type": "php",
  "request": "launch",
  "port": 9003
}
```

### 9.7 Blade / Laravel templating
If you write Blade, add `onecentlin.laravel-blade`. It provides syntax highlighting. Do not add "Laravel Extension Pack" bundles; they include 5+ extensions you don't need.

---

## 10. C# Projects and Solutions (.NET Core & .NET Framework)

*Case Study: A small shop maintaining a mix of modern .NET 8 microservices and a legacy .NET Framework 4.8 WinForms inventory app. Microsoft's tooling wants to force you into a bloated IDE experience. We refuse.*

### 10.1 The Extension Landscape: Avoiding "C# Dev Kit"
**CRITICAL WARNING**: Microsoft will prompt you to install the "C# Dev Kit". **Do not install it.** It is a massive suite that includes solution explorers, test explorers, and telemetry-heavy background services. 
**The Minimalist Choice**: Install *only* the base `ms-dotnettools.csharp` extension (the modern Roslyn language server). It provides syntax highlighting, IntelliSense, and basic refactoring. That is all you need.

### 10.2 .NET Core vs. .NET Framework
- **.NET Core / .NET 5+**: Fully supported in VS Code via the base C# extension and `dotnet` CLI.
- **.NET Framework (4.8 and older)**: VS Code cannot build or debug legacy Framework projects natively without MSBuild/Visual Studio tooling. **Do not try to force it.** For legacy Framework, use VS Code purely as a text editor, and compile via CLI/MSBuild or fall back to full Visual Studio. Embrace the Notepad++ "edit here, compile there" mindset.

### 10.3 Project & Solution Management via CLI
**Do not use GUI Solution Explorers.** Manipulate `.sln` and `.csproj` files via the `dotnet` CLI.
```bash
# Create a new console app
dotnet new console -n MyApp
# Add it to a solution
dotnet sln MyApp.sln add MyApp/MyApp.csproj
# Add a project reference
dotnet add MyApp/MyApp.csproj reference OtherApp/OtherApp.csproj
```

### 10.4 Building and Running via `tasks.json`
Minimalist task configurations. No extensions required.
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "dotnet Build",
      "command": "dotnet",
      "type": "process",
      "args": ["build", "${workspaceFolder}/MyApp.sln"],
      "problemMatcher": "$msCompile"
    },
    {
      "label": "dotnet Watch",
      "command": "dotnet",
      "type": "process",
      "args": ["watch", "run", "--project", "${workspaceFolder}/MyApp/MyApp.csproj"],
      "isBackground": true
    }
  ]
}
```

### 10.5 Debugging without extra extensions
The base C# extension includes the `coreclr` debugger. Configure `launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": ".NET Core Launch (console)",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "dotnet Build",
      "program": "${workspaceFolder}/MyApp/bin/Debug/net8.0/MyApp.dll",
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false
    }
  ]
}
```

### 10.6 Code Style & Formatting
**Do not install StyleCop or ReSharper clones.** Leverage built-in `.editorconfig` support. Create an `.editorconfig` at your solution root:
```ini
root = true
[*]
indent_style = space
indent_size = 4
insert_final_newline = true
[*.cs]
csharp_style_var_for_built_in_types = true:suggestion
```
VS Code's Roslyn server will enforce this automatically.

### 10.7 Package Management
**Do not use GUI package managers.** Use the CLI:
```bash
dotnet add package Newtonsoft.Json --version 13.0.3
dotnet list package
```

### 10.8 Unit Testing
**Do not install heavy third-party test runners.** Run tests via the terminal or tasks:
```json
{
  "label": "dotnet Test",
  "command": "dotnet",
  "type": "process",
  "args": ["test", "${workspaceFolder}/MyApp.sln", "--logger:console;verbosity=normal"]
}
```
If you absolutely need a UI for test results, use the built-in VS Code "Test Explorer" (which the base C# extension supports natively), but avoid extensions like "Test Runner for .NET" which duplicate this functionality.

---

## 11. Extension Discipline: The Anti-Bloat Protocol

### 11.1 The "one in, one out" rule
If you install a new extension, you must delete or disable an existing one. This forces you to evaluate if the new tool actually provides more value than what you have.

### 11.2 Auditing installed extensions
Run this monthly:
```bash
code --list-extensions --show-versions > extensions_backup.txt
```
Review the list. If you don't recognize an extension or haven't used it in a month, uninstall it.

### 11.3 Reading extension `package.json`
Before installing an extension from the marketplace, download its `.vsix`, extract it, and read `package.json`. Look at `activationEvents`. 
- If it says `"*"` (activates on startup), **reject it**. It will slow down your editor.
- If it says `"onLanguage:python"`, it's safe. It only loads when you open a Python file.

### 11.4 Installing extensions manually via `.vsix`
For maximum control and offline use, download the `.vsix` from the marketplace website. Install via CLI:
```bash
code --install-extension my-extension-1.2.3.vsix
```
This prevents auto-updates from silently introducing bloat or telemetry.

### 11.5 Workspace-recommended extensions
Instead of global installs, use `.vscode/extensions.json`:
```json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode"
  ]
}
```
When a new dev opens the project, VS Code prompts them to install *only* what the project needs.

### 11.6 Disabling extensions per-workspace
If you must have an extension globally, disable it in specific workspaces. Open the Extensions sidebar, right-click the extension, and select "Disable (Workspace)".

### 11.7 Recognizing bloat signals
- **High activation time**: Run `Developer: Startup Performance` in the Command Palette. If an extension takes >500ms to activate, remove it.
- **Background processes**: Check your OS task manager. If VS Code spawns 5 Node.js processes when idle, an extension is polling. Kill it.

---

## 12. Backup, Portability, and Sync (Without Microsoft Accounts)

### 12.1 Why avoid Settings Sync
Microsoft's Settings Sync requires a GitHub/Microsoft account, sends your config to their cloud, and often overwrites local tweaks. The minimalist uses local files.

### 12.2 Manual backup script
Create `backup_vscode.sh` (or `.bat`):
```bash
#!/bin/bash
# Assuming Portable Mode in ./data
cp data/user-data/User/settings.json ./backup/settings.json
cp data/user-data/User/keybindings.json ./backup/keybindings.json
cp -r data/user-data/User/snippets ./backup/snippets
code --list-extensions --show-versions > ./backup/extensions.txt
```

### 12.3 Restoring on a fresh machine
Create `restore_vscode.sh`:
```bash
#!/bin/bash
cp ./backup/settings.json data/user-data/User/settings.json
cp ./backup/keybindings.json data/user-data/User/keybindings.json
cp -r ./backup/snippets data/user-data/User/snippets
while read ext; do
  code --install-extension "$ext"
done < ./backup/extensions.txt
```

### 12.4 Portable-mode USB workflow
Keep your `VSCode_Portable` folder on a fast USB-C drive. Plug it into any Windows/Mac/Linux machine, run `Code.exe`, and you have your exact environment, extensions, and settings. No installation required.

### 12.5 Symlinking config into a git repo (dotfiles-style)
If not using portable mode, symlink your config to a Git repo:
```bash
# Linux/macOS
ln -s ~/dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
# Windows (PowerShell Admin)
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Code\User\settings.json" -Target "C:\dotfiles\vscode\settings.json"
```

---

## 13. Performance Tuning & Troubleshooting

### 13.1 Startup time audit
If VS Code feels sluggish, run `Developer: Startup Performance`. Look for extensions with high "Activation" times. 

### 13.2 Disabling unused built-in extensions
VS Code ships with extensions for Grunt, Gulp, Jake, npm, and more. If you don't use them, disable them.
CLI: `code --disable-extension vsix.vscode-grunt`
Or via UI: Search `@builtin grunt` and disable.

### 13.3 Exclusions for large repos
This is the #1 performance fix. If you have `node_modules`, `.git`, or `dist` folders, exclude them from file watching and searching:
```json
"files.watcherExclude": {
  "**/.git/objects/**": true,
  "**/.git/subtree-cache/**": true,
  "**/node_modules/**": true,
  "**/dist/**": true
},
"search.exclude": {
  "**/node_modules": true,
  "**/dist": true,
  "**/package-lock.json": true
}
```

### 13.4 Renderer and GPU acceleration flags
If you experience screen tearing or high GPU usage, disable hardware acceleration in `argv.json`:
```json
"disable-hardware-acceleration": true
```
Conversely, if rendering is slow, ensure it's set to `false` (meaning acceleration is *enabled*).

### 13.5 Diagnosing issues
If VS Code crashes or hangs, launch it with extensions disabled to isolate the issue:
```bash
code --disable-extensions .
```
If the problem disappears, an extension is the culprit. Re-enable them one by one.

---

## 14. Appendices

### A. Quick-reference: default keybindings cheat sheet
- `Ctrl+P`: Go to File
- `Ctrl+Shift+P`: Command Palette
- `Ctrl+Shift+O`: Go to Symbol
- `Ctrl+G`: Go to Line
- `F12`: Go to Definition
- `Shift+F12`: Find References
- `Ctrl+D`: Select Next Occurrence
- `Ctrl+Shift+L`: Select All Occurrences
- `Alt+Up/Down`: Move Line Up/Down
- `Shift+Alt+Up/Down`: Copy Line Up/Down
- `Ctrl+/`: Toggle Line Comment
- `Ctrl+Shift+A`: Toggle Block Comment

### B. Starter `settings.json` (Zero Bloat)
```json
{
  // UI & Visuals
  "editor.minimap.enabled": false,
  "editor.renderWhitespace": "selection",
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true,
  "workbench.activityBar.location": "top",
  
  // Behavior
  "editor.formatOnSave": true,
  "editor.defaultFormatter": null,
  "editor.tabSize": 4,
  "editor.insertSpaces": true,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "files.autoSave": "onFocusChange",
  
  // Performance
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/node_modules/**": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/dist": true
  },
  
  // Telemetry & Trust
  "telemetry.telemetryLevel": "off",
  "security.workspace.trust.enabled": false,
  "extensions.autoUpdate": false
}
```

### C. Starter `keybindings.json` with N++-friendly remaps
```json
[
  {
    "key": "ctrl+shift+r",
    "command": "editor.action.addSelectionToNextFindMatch",
    "when": "editorFocus"
  },
  {
    "key": "ctrl+d",
    "command": "editor.action.copyLinesDownAction",
    "when": "editorTextFocus && !editorReadonly"
  },
  {
    "key": "shift+alt+down",
    "command": "-editor.action.copyLinesDownAction"
  }
]
```

### D. Recommended `.vscode/extensions.json` templates

**React/TS:**
```json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode"
  ]
}
```

**Python:**
```json
{
  "recommendations": [
    "ms-python.python",
    "charliermarsh.ruff"
  ]
}
```

**PHP:**
```json
{
  "recommendations": [
    "bmewburn.vscode-intelephense-client",
    "xdebug.php-debug"
  ]
}
```

**C#:**
```json
{
  "recommendations": [
    "ms-dotnettools.csharp"
  ]
}
```

### E. Glossary
- **Workspace**: A `.code-workspace` file defining multiple folders and specific settings for a project context.
- **Profile**: A named configuration of settings and extensions (e.g., "Web", "Python") to isolate contexts.
- **Contribution Point**: How an extension adds features to VS Code (e.g., commands, menus, languages) defined in its `package.json`.
- **Activation Event**: The trigger that loads an extension into memory (e.g., `onLanguage:python`, `onCommand:ext.run`).
- **`when` clause**: A boolean expression in keybindings or menus that restricts their availability based on UI context (e.g., `editorTextFocus`).