-- Plugin entry point for claude-shuttle
-- Prevents the plugin from loading twice
if vim.g.loaded_claude_shuttle then
  return
end
vim.g.loaded_claude_shuttle = true

-- Create user commands
vim.api.nvim_create_user_command("Claudev", function(opts)
  local start_line = opts.line1
  local end_line = opts.line2

  -- If no range specified, start_line and end_line will both be current line
  -- We only want to send code if user explicitly selected a range
  if opts.range > 0 then
    require("claude-shuttle").claudev(start_line, end_line)
  else
    require("claude-shuttle").claudev()
  end
end, {
  range = true,
  desc = "Open Claude CLI in vertical tmux split"
})

vim.api.nvim_create_user_command("Claudeh", function(opts)
  local start_line = opts.line1
  local end_line = opts.line2

  -- If no range specified, start_line and end_line will both be current line
  -- We only want to send code if user explicitly selected a range
  if opts.range > 0 then
    require("claude-shuttle").claudeh(start_line, end_line)
  else
    require("claude-shuttle").claudeh()
  end
end, {
  range = true,
  desc = "Open Claude CLI in horizontal tmux split"
})