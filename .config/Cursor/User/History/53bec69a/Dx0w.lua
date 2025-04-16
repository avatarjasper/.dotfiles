local M = {}

-- State variable to track if we're in tab mode
M.tab_mode_active = false

-- Store the original background color
M.original_background = nil

-- Store keymappings
M.tab_mode_keys = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
                   's', '/', '\\', '~', 'h', 'p', 'b', 
                   '<space>', '<BS>', 'dw', 't', 'F'}

-- Maximum line length for tab lines
M.MAX_LINE_LENGTH = 61

-- Helper function to check if a line is a tab line (starts with note and pipe)
local function is_tab_line(line)
  return line:match("^[eEABGD]|")
end

-- Helper function to get the prefix of a tab line (e.g., "e|" or "B|")
local function get_tab_prefix(line)
  if is_tab_line(line) then
    return line:sub(1, 2)
  end
  return nil
end

-- Helper function to split a long tab line into chunks of MAX_LINE_LENGTH
local function split_tab_line(line)
  local prefix = get_tab_prefix(line)
  if not prefix then return {line} end
  
  local content = line:sub(3)  -- Remove prefix
  local chunks = {}
  local chunk_size = M.MAX_LINE_LENGTH - 2  -- Account for prefix length
  
  while #content > 0 do
    -- Find the last complete column (ending with |) that fits
    local end_pos = chunk_size
    while end_pos > 0 and content:sub(end_pos, end_pos) ~= "|" do
      end_pos = end_pos - 1
    end
    
    -- If we couldn't find a column end, use the full chunk size and add a |
    if end_pos == 0 then 
      end_pos = chunk_size - 1  -- Leave room for the |
    end
    
    -- Extract the chunk, ensure it ends with | and add the prefix
    local chunk_content = content:sub(1, end_pos)
    if chunk_content:sub(-1) ~= "|" then
      chunk_content = chunk_content .. "|"
    end
    local chunk = prefix .. chunk_content
    table.insert(chunks, chunk)
    
    -- Remove the processed part
    content = content:sub(end_pos + 1)
  end
  
  return chunks
end

function M.format_document()
  if not M.tab_mode_active then return end
  
  -- Get all lines from the buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local new_lines = {}
  local current_block = {}
  local i = 1
  
  while i <= #lines do
    local line = lines[i]
    
    -- If this is a tab line
    if is_tab_line(line) then
      -- Collect the entire block
      current_block = {line}
      local j = i + 1
      while j <= #lines and is_tab_line(lines[j]) do
        table.insert(current_block, lines[j])
        j = j + 1
      end
      i = j - 1
      
      -- Process the block
      local blocks_to_add = {}
      local max_chunks = 1
      
      -- Split each line in the block and determine how many chunks we'll need
      for _, block_line in ipairs(current_block) do
        local chunks = split_tab_line(block_line)
        max_chunks = math.max(max_chunks, #chunks)
        blocks_to_add[#blocks_to_add + 1] = chunks
      end
      
      -- Add each chunk as a new block
      for chunk_index = 1, max_chunks do
        -- Add the current chunk of each line
        for line_index, line_chunks in ipairs(blocks_to_add) do
          if chunk_index <= #line_chunks then
            table.insert(new_lines, line_chunks[chunk_index])
          else
            -- If this line doesn't have this chunk, add a blank tab line
            local prefix = get_tab_prefix(current_block[line_index])
            table.insert(new_lines, prefix .. string.rep("-", M.MAX_LINE_LENGTH - 2))
          end
        end
        
        -- Add a blank line between blocks if there are more chunks
        if chunk_index < max_chunks then
          table.insert(new_lines, "")
        end
      end
    else
      -- Non-tab line, just add it as is
      table.insert(new_lines, line)
    end
    
    i = i + 1
  end
  
  -- Replace buffer contents
  vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
end

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

function M.insert_tab_template()
  if not M.tab_mode_active then return end
  
  -- Get cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row = cursor_pos[1]
  
  -- Template lines
  local template = {
    "e|----------------------------------------------------------|",
    "B|----------------------------------------------------------|",
    "G|----------------------------------------------------------|",
    "D|----------------------------------------------------------|",
    "A|----------------------------------------------------------|",
    "E|----------------------------------------------------------|"
  }
  
  -- Insert template at cursor position
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, template)
  
  -- Move cursor to the start of the template
  vim.api.nvim_win_set_cursor(0, {row, 2})
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
    -- Numbers
    for i = 0, 9 do
      vim.keymap.set('n', tostring(i), function() M.replace_with_number(i) end, {
        desc = string.format("Replace dash with number %d (in tab mode)", i),
        silent = true,
        buffer = 0
      })
    end
    
    -- Special characters
    local special_chars = {
      s = 's', ['/'] = '/', ['\\'] = '\\', ['~'] = '~',
      h = 'h', p = 'p', b = 'b'
    }
    
    for key, char in pairs(special_chars) do
      vim.keymap.set('n', key, function() M.replace_with_char(char) end, {
        silent = true,
        buffer = 0
      })
    end
    
    -- Other mappings
    vim.keymap.set('n', '<space>', M.insert_vertical_dashes, { 
      silent = true,
      buffer = 0
    })
    
    vim.keymap.set('n', '<BS>', M.remove_vertical_dashes, {
      silent = true,
      buffer = 0
    })
    
    vim.keymap.set('n', 'dw', M.replace_numbers_with_dashes, {
      silent = true,
      buffer = 0
    })
    
    -- Template mapping
    vim.keymap.set('n', 't', M.insert_tab_template, {
      desc = "Insert guitar tab template",
      silent = true,
      buffer = 0
    })
    
    -- Format document mapping
    vim.keymap.set('n', 'F', M.format_document, {
      desc = "Format guitar tab document",
      silent = true,
      buffer = 0
    })
    
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
    
    -- Clear all buffer-local mappings
    for _, key in ipairs(M.tab_mode_keys) do
      pcall(vim.keymap.del, 'n', key, { buffer = 0 })
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
  vim.api.nvim_create_user_command("ReplaceNumbersWithDashes", M.replace_numbers_with_dashes, {})
  vim.api.nvim_create_user_command("InsertTabTemplate", M.insert_tab_template, {})
  vim.api.nvim_create_user_command("FormatDocument", M.format_document, {})

  -- Set up Alt+Shift+T to toggle tab mode
  vim.keymap.set('n', '<M-T>', M.toggle_tab_mode, {
    desc = "Toggle tab mode",
    silent = true
  })
end

-- Return the module
return M
