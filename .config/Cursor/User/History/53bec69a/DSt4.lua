local M = {}

-- State variable to track if we're in tab mode
M.tab_mode_active = false

-- Store the original background color
M.original_background = nil

function M.insert_vertical_dashes()
  if not M.tab_mode_active then return end
  
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
    
    -- Insert the dash by splitting the line and adding the dash between parts
    local before = line:sub(1, col)
    local after = line:sub(col + 1)
    line = before .. "-" .. after
    
    -- Set the modified line back
    vim.api.nvim_buf_set_lines(0, target_row - 1, target_row, false, {line})
  end
end

function M.remove_vertical_dashes()
  if not M.tab_mode_active then return end
  
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1], cursor_pos[2]
  
  -- Remove dashes vertically
  for i = 0, 5 do
    local target_row = row + i
    -- Check if we're still within buffer bounds
    if target_row <= vim.api.nvim_buf_line_count(0) then
      -- Get the current line
      local line = vim.api.nvim_buf_get_lines(0, target_row - 1, target_row, false)[1]
      
      -- Only proceed if the line is long enough and has a dash at the position
      if #line >= col + 1 and line:sub(col + 1, col + 1) == "-" then
        -- Remove the dash by joining the parts before and after it
        local before = line:sub(1, col)
        local after = line:sub(col + 2)
        line = before .. after
        
        -- Set the modified line back
        vim.api.nvim_buf_set_lines(0, target_row - 1, target_row, false, {line})
      end
    end
  end
end

function M.replace_with_number(number)
  if not M.tab_mode_active then return end
  
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1], cursor_pos[2]
  
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
  
  -- Only proceed if there's a dash at the current position
  if #line >= col + 1 and line:sub(col + 1, col + 1) == "-" then
    -- Replace the dash with the number
    local before = line:sub(1, col)
    local after = line:sub(col + 2)
    line = before .. number .. after
    
    -- Set the modified line back
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, {line})
    
    -- Move cursor down one line
    if row < vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, {row + 1, col})
    end
  end
end

function M.toggle_tab_mode()
  M.tab_mode_active = not M.tab_mode_active
  
  if M.tab_mode_active then
    -- Store current background color if we haven't already
    if not M.original_background then
      M.original_background = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    end
    
    -- Set dark green background (using a darker shade of green)
    vim.api.nvim_set_hl(0, "Normal", { bg = "#1a3a1a" })
    
    -- Show message
    vim.notify("Tab mode activated", vim.log.levels.INFO)
  else
    -- Restore original background
    if M.original_background then
      vim.api.nvim_set_hl(0, "Normal", { bg = M.original_background })
    else
      -- If no original background stored, reset to default
      vim.api.nvim_set_hl(0, "Normal", {})
    end
    
    -- Show message
    vim.notify("Tab mode deactivated", vim.log.levels.INFO)
  end
end

-- Function to set up the plugin
function M.setup(opts)
  -- Merge user options with defaults
  opts = opts or {}

  -- Create the user commands
  vim.api.nvim_create_user_command("InsertVerticalDashes", M.insert_vertical_dashes, {})
  vim.api.nvim_create_user_command("RemoveVerticalDashes", M.remove_vertical_dashes, {})
  vim.api.nvim_create_user_command("ToggleTabMode", M.toggle_tab_mode, {})

  -- Set up key mappings
  -- Alt+Shift+T to toggle tab mode
  vim.keymap.set('n', '<M-T>', M.toggle_tab_mode, {
    desc = "Toggle tab mode",
    silent = true
  })
  
  -- Space and Backspace only work in tab mode (checked within the functions)
  vim.keymap.set('n', '<space>', M.insert_vertical_dashes, { 
    desc = "Insert 6 vertical dashes (in tab mode)",
    silent = true
  })
  
  vim.keymap.set('n', '<BS>', M.remove_vertical_dashes, {
    desc = "Remove 6 vertical dashes (in tab mode)",
    silent = true
  })
  
  -- Number keys (0-9) to replace dashes with numbers
  for i = 0, 9 do
    vim.keymap.set('n', tostring(i), function() M.replace_with_number(i) end, {
      desc = string.format("Replace dash with number %d (in tab mode)", i),
      silent = true
    })
  end
end

-- Return the module
return M
