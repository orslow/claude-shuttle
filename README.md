# claude-shuttle

A Neovim plugin for sending code blocks to Claude CLI within tmux.

## Overview

claude-shuttle enables seamless code sharing between Neovim and Claude CLI running in separate tmux panes. Select code in Neovim, run `:Shuttle`, and the code appears in your Claude pane with file path and line number annotations.

## Features

- 🚀 Send selected code blocks to existing Claude CLI pane
- 📍 Automatic file path and line number annotations
- 🔍 Smart Claude pane detection using process tree analysis
- 🎯 Auto-focus on Claude pane after sending code
- 🌐 Language-aware code fencing (e.g., ```python)
- 📂 Relative path formatting from working directory

## Requirements

- tmux 3.2+
- Neovim 0.8+
- Claude CLI running in a tmux pane (e.g., `claude` command)
- Must be running inside tmux session (TMUX environment variable set)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'orslow/claude-shuttle',
  config = function()
    require('claude-shuttle').setup()
  end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'orslow/claude-shuttle',
  config = function()
    require('claude-shuttle').setup()
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'orslow/claude-shuttle'
```

## Usage

### Basic Workflow

1. Start Claude CLI in a tmux pane:
   ```bash
   claude
   ```

2. In your Neovim pane, select code in visual mode and run:
   ```vim
   :'<,'>Shuttle
   ```

3. The selected code is sent to Claude with file path and line annotations

### Example

When you select lines 10-25 in `src/main.py` and run `:Shuttle`, Claude receives:

```
@src/main.py#L10-25
```python
def hello_world():
    print("Hello, World!")
    return True
```
```

### Keybinding Suggestion

Add to your Neovim config for quick access:

```lua
vim.keymap.set('v', '<leader>cs', ':Shuttle<CR>', { desc = 'Send to Claude' })
```

Or in VimScript:

```vim
vnoremap <leader>cs :Shuttle<CR>
```

## How It Works

1. **Pane Detection**: Searches all panes in the current tmux window for a process matching "claude" using `ps` and process tree analysis
2. **Message Formatting**: Creates a message with:
   - File path anchor: `@path/to/file#L10-25`
   - Language-specific code fence: `` ```python ``
   - Selected code content
3. **Transmission**: Uses tmux's `load-buffer` and `paste-buffer` to send the formatted message
4. **Focus Switch**: Automatically switches to the Claude pane after sending

## Error Handling

- **Not in tmux**: Displays error if TMUX environment variable is not set
- **No selection**: Displays error if no visual selection is made
- **No Claude pane**: Displays error if no Claude process is found in the current tmux window

## Configuration

Currently no configuration options are required. The plugin works out of the box.

```lua
require('claude-shuttle').setup()
```

Future configuration options may include:
- Custom Claude process name patterns
- Custom message formatting
- Pane search scope (window vs session)

## Troubleshooting

### "No Claude pane found" error

1. Ensure Claude CLI is running in a pane in the same tmux window
2. Check that the process name contains "claude" (case-insensitive)
3. Try running `tmux list-panes -a` to verify panes

### Code not appearing in Claude

1. Verify Claude pane is in a responsive state (not showing a prompt that requires input)
2. Check tmux version: `tmux -V` (requires 3.2+)
3. Test tmux buffer manually: `tmux load-buffer - <<<'test' && tmux paste-buffer`

## License

MIT

## Contributing

Issues and pull requests are welcome!
