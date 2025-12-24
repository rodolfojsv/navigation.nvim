-- navigation/core.lua
-- Core navigation logic

-- Module configuration (set by init.lua)
local config = {}

function InitializeConfig(user_config)
  config = user_config
end

function OpenNavigation()
  -- Check if the navigation file exists
  local file = io.open(config.nav_file, 'r')
  if not file then
    vim.notify('Navigation file not found: ' .. config.nav_file, vim.log.levels.ERROR)
    return
  end
  
  -- Read all lines from the file
  local files = {}
  for line in file:lines() do
    -- Trim whitespace and skip empty lines
    local trimmed = line:match('^%s*(.-)%s*$')
    if trimmed ~= '' then
      table.insert(files, trimmed)
    end
  end
  file:close()
  
  if #files == 0 then
    vim.notify('No files found in navigation file', vim.log.levels.WARN)
    return
  end
  
  -- Show selector
  vim.ui.select(files, {
    prompt = 'Select file or directory:',
    format_item = function(item)
      -- Show just the filename/dirname if it's a full path, otherwise show as-is
      local name = item:match('([^/\\]+)$') or item
      -- Check if it's a directory
      local is_dir = vim.fn.isdirectory(item) == 1
      local prefix = is_dir and '[DIR] ' or ''
      return prefix .. name .. ' (' .. item .. ')'
    end,
  }, function(choice)
    if choice then
      -- Check if the choice is a directory
      if vim.fn.isdirectory(choice) == 1 then
        -- Change working directory to the selected directory if auto_cd is enabled
        if config.auto_cd then
          vim.cmd('cd ' .. vim.fn.fnameescape(choice))
          if config.show_notifications then
            vim.notify('Changed directory to: ' .. choice, vim.log.levels.INFO)
          end
        end
        -- Open directory in file explorer
        vim.cmd('edit ' .. vim.fn.fnameescape(choice))
      else
        -- Open the selected file
        vim.cmd('edit ' .. vim.fn.fnameescape(choice))
      end
    end
  end)
end

function AddCurrentDirectoryToNav()
  -- Get the current file path, or fallback to current working directory
  local current_file = vim.fn.expand('%:p')
  local path_to_add
  local item_type
  
  -- Check if we're in an oil.nvim buffer
  local buftype = vim.bo.filetype
  if buftype == 'oil' then
    -- In oil.nvim, try to get the directory from oil API or buffer variable
    local ok, oil = pcall(require, 'oil')
    if ok then
      path_to_add = oil.get_current_dir()
      if path_to_add then
        -- Remove trailing slash if present
        path_to_add = path_to_add:gsub('[\\/]$', '')
        item_type = 'directory'
      end
    end
    -- Fallback if oil API doesn't work
    if not path_to_add then
      path_to_add = vim.fn.getcwd()
      item_type = 'directory'
    end
  -- Check if we're in a netrw buffer
  elseif buftype == 'netrw' or vim.fn.exists('b:netrw_curdir') == 1 then
    -- In netrw, get the directory being browsed
    path_to_add = vim.b.netrw_curdir or vim.fn.getcwd()
    item_type = 'directory'
  elseif current_file ~= '' and vim.fn.filereadable(current_file) == 1 then
    -- A file is open and readable
    path_to_add = current_file
    item_type = 'file'
  else
    -- No file open or not readable, use current working directory
    path_to_add = vim.fn.getcwd()
    item_type = 'directory'
  end
  
  -- Check if the navigation file exists, create if it doesn't
  local file = io.open(config.nav_file, 'r')
  local existing_paths = {}
  
  if file then
    -- Read existing paths to avoid duplicates
    for line in file:lines() do
      local trimmed = line:match('^%s*(.-)%s*$')
      if trimmed ~= '' then
        existing_paths[trimmed] = true
      end
    end
    file:close()
  end
  
  -- Check if path is already in the navigation file
  if existing_paths[path_to_add] then
    if config.show_notifications then
      vim.notify(item_type:gsub("^%l", string.upper) .. ' already in navigation file: ' .. path_to_add, vim.log.levels.INFO)
    end
    return
  end
  
  -- Check if the file ends with a newline
  local needs_newline = false
  if vim.fn.filereadable(config.nav_file) == 1 then
    file = io.open(config.nav_file, 'r')
    if file then
      file:seek('end', -1)
      local last_char = file:read(1)
      if last_char and last_char ~= '\n' and last_char ~= '\r' then
        needs_newline = true
      end
      file:close()
    end
  end
  
  -- Append the path to the navigation file
  file = io.open(config.nav_file, 'a')
  if not file then
    vim.notify('Failed to open navigation file for writing: ' .. config.nav_file, vim.log.levels.ERROR)
    return
  end
  
  if needs_newline then
    file:write('\n')
  end
  file:write(path_to_add .. '\n')
  file:close()
  
  if config.show_notifications then
    vim.notify('Added ' .. item_type .. ' to navigation: ' .. path_to_add, vim.log.levels.INFO)
  end
end
