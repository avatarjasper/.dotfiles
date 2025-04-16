local M = {}

-- State variable to track if we're in tab mode
M.tab_mode_active = false

-- Store the original background color
M.original_background = nil

-- Store keymappings
M.tab_mode_mappings = {}

-- Helper function to find the top row of a dash block
local function find_block_bounds(current_row, col)
  local top_row = current_row
  local bottom_row = current_row
  
  -- Search upward for the top of the block
  while top_row > 1 do
    local line = vim.api.nvim_buf_get_lines(0, top_row - 2, top_row - 1, false)[1]
    if not line or #line < col + 1 or line:sub(col + 1, col + 1) ~= "-" then
      break
    end
    top_row = top_row - 1
  end
  
  -- Search downward for the bottom of the block
  local total_lines = vim.api.nvim_buf_line_count(0)
  while bottom_row < total_lines do
    local line = vim.api.nvim_buf_get_lines(0, bottom_row, bottom_row + 1, false)[1]
    if not line or #line < col + 1 or line:sub(col + 1, col + 1) ~= "-" then
      break
    end
    bottom_row = bottom_row + 1
  end
  
  return top_row, bottom_row
end

-- Helper function to find the next dash in a line
local function find_next_dash(line, start_col)
  for i = start_col + 1, #line do
    if line:sub(i, i) == "-" then
      return i
    end
  end
  return nil
end

function M.replace_with_char(char)
  if not M.tab_mode_active then return end
  
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1], cursor_pos[2]
  
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
  
  -- Only proceed if there's a dash at the current position
  if #line >= col + 1 and line:sub(col + 1, col + 1) == "-" then
    -- Replace the dash with the character
    local before = line:sub(1, col)
    local after = line:sub(col + 2)
    line = before .. char .. after
    
    -- Set the modified line back
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, {line})
  end
end

function M.insert_vertical_dashes()
  if not M.tab_mode_active then return end
  
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_row, col = cursor_pos[1], cursor_pos[2]
  
  -- Find the block bounds if we're in a dash block
  local top_row, bottom_row = find_block_bounds(current_row, col)
  
  -- If we're not in a dash block, create a new 6-line block
  if bottom_row - top_row + 1 ~= 6 then
    top_row = current_row
    bottom_row = current_row + 5
  end
  
  -- Ensure we have enough lines
  local total_lines = vim.api.nvim_buf_line_count(0)
  if bottom_row > total_lines then
    local lines_to_add = bottom_row - total_lines
    local empty_lines = {}
    for _ = 1, lines_to_add do
      table.insert(empty_lines, "")
    end
    vim.api.nvim_buf_set_lines(0, -1, -1, false, empty_lines)
  end
  
  -- Insert dashes for each row
  for row = top_row, bottom_row do
    -- Get the current line
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    
    -- Extend the line with spaces if needed
    while #line < col do
      line = line .. " "
    end
    
    -- Insert the dash
    local before = line:sub(1, col)
    local after = line:sub(col + 1)
    line = before .. "-" .. after
    
    -- Set the modified line back
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, {line})
  end
  
  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, {current_row, col})
end

function M.remove_vertical_dashes()
  if not M.tab_mode_active then return end
  
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_row, col = cursor_pos[1], cursor_pos[2]
  
  -- Find the block bounds
  local top_row, bottom_row = find_block_bounds(current_row, col)
  
  -- Remove dashes in this column
  for row = top_row, bottom_row do
    -- Get the current line
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    
    -- Only proceed if there's a dash at the position
    if #line >= col + 1 and line:sub(col + 1, col + 1) == "-" then
      -- Remove the dash
      local before = line:sub(1, col)
      local after = line:sub(col + 2)
      -- Remove trailing spaces if this was the last character
      if #after == 0 and before:match("^%s*$") then
        before = ""
      end
      line = before .. after
      
      -- Set the modified line back
      vim.api.nvim_buf_set_lines(0, row - 1, row, false, {line})
    end
  end
  
  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, {current_row, col})
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
  end
end

function M.replace_numbers_with_dashes()
  if not M.tab_mode_active then return end
  
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1], cursor_pos[2]
  
  -- Get the current line
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
  
  -- Find the next dash position
  local next_dash_col = find_next_dash(line, col)
  if not next_dash_col then return end
  
  -- Replace any numbers between the current position and next dash with dashes
  local before = line:sub(1, col)
  local middle = string.rep("-", next_dash_col - col - 1)
  local after = line:sub(next_dash_col)
  line = before .. middle .. after
  
  -- Set the modified line back
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, {line})
  
  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, {row, col})
end

function M.toggle_tab_mode()
  M.tab_mode_active = not M.tab_mode_active
  
  if M.tab_mode_active then
    -- Store current background color if we haven't already
    if not M.original_background then
      M.original_background = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    end
    
    -- Set dark green background
    vim.api.nvim_set_hl(0, "Normal", { bg = "#1a3a1a" })
    
    -- Set up tab mode mappings
    M.tab_mode_mappings = {
      -- Numbers
      unpack(vim.tbl_map(function(i)
        return vim.keymap.set('n', tostring(i), function() M.replace_with_number(i) end, {
          desc = string.format("Replace dash with number %d (in tab mode)", i),
          silent = true
        })
      end, {0,1,2,3,4,5,6,7,8,9})),
      
      -- Special characters
      vim.keymap.set('n', 's', function() M.replace_with_char('s') end, { silent = true }),
      vim.keymap.set('n', '/', function() M.replace_with_char('/') end, { silent = true }),
      vim.keymap.set('n', '\\', function() M.replace_with_char('\\') end, { silent = true }),
      vim.keymap.set('n', '~', function() M.replace_with_char('~') end, { silent = true }),
      vim.keymap.set('n', 'h', function() M.replace_with_char('h') end, { silent = true }),
      vim.keymap.set('n', 'p', function() M.replace_with_char('p') end, { silent = true }),
      vim.keymap.set('n', 'b', function() M.replace_with_char('b') end, { silent = true }),
      
      -- Other mappings
      vim.keymap.set('n', '<space>', M.insert_vertical_dashes, { silent = true }),
      vim.keymap.set('n', '<BS>', M.remove_vertical_dashes, { silent = true }),
      vim.keymap.set('n', 'dw', M.replace_numbers_with_dashes, { silent = true })
    }
    
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
    
    -- Remove all tab mode mappings
    for _, mapping in ipairs(M.tab_mode_mappings) do
      pcall(vim.keymap.del, 'n', mapping.lhs)
    end
    M.tab_mode_mappings = {}
    
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
  vim.api.nvim_create_user_command("ReplaceNumbersWithDashes", M.replace_numbers_with_dashes, {})

  -- Set up Alt+Shift+T to toggle tab mode
  vim.keymap.set('n', '<M-T>', M.toggle_tab_mode, {
    desc = "Toggle tab mode",
    silent = true
  })
end

-- Return the module
return M
