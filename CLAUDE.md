# claude-shuttle

A Neovim plugin for seamlessly sending code blocks to Claude CLI within tmux.

## Purpose

This plugin enables you to send selected code blocks from Neovim to an existing Claude CLI pane in tmux, complete with file path and line number references.

**Key assumption:** Neovim is always running inside a tmux session, and Claude CLI is already running in another pane.

## Requirements

- **tmux** 3.2 or higher (uses `list-panes`, `load-buffer`, `paste-buffer`, `select-pane`)
- **Neovim** 0.8 or higher
- **Claude CLI** must be running in another pane within the same tmux session
- **TMUX environment variable** must be set (automatically set when running inside tmux)

## Core Features

### `:'<,'>Shuttle`

Sends the visually selected lines to the Claude pane running in the current tmux window.

**How it works:**

1. Searches for a Claude process in all panes of the current tmux window (using process tree analysis)
2. When found, sends the selected code block with path and line anchor information
3. Automatically switches focus to the Claude pane after transmission

**Path format:** Relative path based on Neovim's working directory

**Anchor format:**
- Single line: `@path/to/file#L10`
- Range: `@path/to/file#L10-25`

**Code blocks** use language-specific fences matching the file type (e.g., ` ```python `)

If no Claude pane is found, an error message is displayed.

