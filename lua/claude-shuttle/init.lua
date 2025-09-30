local M = {}

-- Default configuration
M.config = {
  claude_cmd = "claude"
}

-- Setup function to allow user configuration
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Check if running inside tmux
local function is_in_tmux()
  return vim.env.TMUX ~= nil
end

-- Get relative path from initial working directory
local function get_relative_path(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local cwd = vim.fn.getcwd()

  if filepath:sub(1, #cwd) == cwd then
    return filepath:sub(#cwd + 2)
  end

  return filepath
end

-- Get file language for code fence
local function get_language(bufnr)
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if ft == "" then
    return ""
  end
  return ft
end

-- Create line anchor format
local function create_anchor(filepath, start_line, end_line)
  if start_line == end_line then
    return string.format("@%s#L%d", filepath, start_line)
  else
    return string.format("@%s#L%d-%d", filepath, start_line, end_line)
  end
end

-- Send code block to Claude pane
local function send_to_claude(start_line, end_line)
  if not is_in_tmux() then
    vim.notify("claude-shuttle: Not running inside tmux", vim.log.levels.ERROR)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = get_relative_path(bufnr)
  local lang = get_language(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

  -- Create the message to send
  local anchor = create_anchor(filepath, start_line, end_line)
  local code_block = table.concat(lines, "\n")

  -- Format the complete message
  local message = string.format("%s\n```%s\n%s\n```", anchor, lang, code_block)

  -- Escape the message for tmux
  -- We need to replace newlines and special characters
  local escaped = message:gsub("'", "'\\''")

  -- Use tmux load-buffer and paste-buffer to send the text
  local tmux_cmd = string.format(
    "tmux load-buffer - <<'EOF'\n%s\nEOF",
    message
  )

  vim.fn.system(tmux_cmd)

  -- Get the target pane (the last pane, which should be the Claude pane)
  local target_pane = vim.fn.system("tmux list-panes -F '#{pane_id}' | tail -1"):gsub("\n", "")

  -- Paste the buffer and send Enter
  vim.fn.system(string.format("tmux paste-buffer -t %s", target_pane))
  vim.fn.system(string.format("tmux send-keys -t %s Enter", target_pane))

  vim.notify("Sent code block to Claude", vim.log.levels.INFO)
end

-- Open Claude in a new tmux pane (vertical split)
function M.claudev(start_line, end_line)
  if not is_in_tmux() then
    vim.notify("claude-shuttle: Not running inside tmux", vim.log.levels.ERROR)
    return
  end

  -- Create vertical split with Claude
  local cmd = string.format("tmux split-window -h '%s'", M.config.claude_cmd)
  vim.fn.system(cmd)

  -- If range is provided, send the code block
  if start_line and end_line then
    -- Wait a bit for the pane to be ready
    vim.defer_fn(function()
      send_to_claude(start_line, end_line)
    end, 500)
  end
end

-- Open Claude in a new tmux pane (horizontal split)
function M.claudeh(start_line, end_line)
  if not is_in_tmux() then
    vim.notify("claude-shuttle: Not running inside tmux", vim.log.levels.ERROR)
    return
  end

  -- Create horizontal split with Claude
  local cmd = string.format("tmux split-window -v '%s'", M.config.claude_cmd)
  vim.fn.system(cmd)

  -- If range is provided, send the code block
  if start_line and end_line then
    -- Wait a bit for the pane to be ready
    vim.defer_fn(function()
      send_to_claude(start_line, end_line)
    end, 500)
  end
end

return M