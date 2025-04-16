local M = {}

function M.insert_vertical_dashes()
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1], cursor_pos[2]
  
  -- Insert 6 dashes vertically
  for i = 0, 5 do
    -- Move to the correct row and column
    local target_row = row + i
    -- Extend the buffer if needed
    if target_row > vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_buf_set_lines(0, -1, -1, false, {""})
    end
    
    -- Get the current line
    local line = vim.api.nvim_buf_get_lines(0, target_row - 1, target_row, false)[1]
    
    -- Extend the line with spaces if needed
    while #line < col do
      line = line .. " "
    end
    
    -- Insert the dash
    if #line == col then
      line = line .. "-"
    else
      line = line:sub(1, col) .. "-" .. line:sub(col + 2)
    end
    
    -- Set the modified line back
    vim.api.nvim_buf_set_lines(0, target_row - 1, target_row, false, {line})
  end
end

-- Function to set up the plugin
function M.setup(opts)
  -- Merge user options with defaults
  opts = opts or {}

  -- Create the user command
  vim.api.nvim_create_user_command("InsertVerticalDashes", M.insert_vertical_dashes, {})

  -- Set up the space key mapping
  vim.keymap.set('n', '<space>', M.insert_vertical_dashes, { 
    desc = "Insert 6 vertical dashes",
    silent = true
  })
end

-- Return the module
return M
