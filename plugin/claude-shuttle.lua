-- Plugin entry point for claude-shuttle
-- Prevents the plugin from loading twice
if vim.g.loaded_claude_shuttle then
  return
end
vim.g.loaded_claude_shuttle = true

-- Create Shuttle command
vim.api.nvim_create_user_command("Shuttle", function(opts)
  local start_line = opts.line1
  local end_line = opts.line2

  -- Only proceed if user selected a range
  if opts.range > 0 then
    require("claude-shuttle").shuttle(start_line, end_line)
  else
    require("claude-shuttle").shuttle()
  end
end, {
  range = true,
  desc = "Send selected code block to existing Claude pane"
})