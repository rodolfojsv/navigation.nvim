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
