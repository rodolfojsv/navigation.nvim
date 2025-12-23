-- navigation/init.lua
-- Main entry point for navigation.nvim

require('navigation.core')
require('plugin.navigation')

local M = {}

-- Default configuration
local defaults = {
  nav_file = vim.fn.expand('~') .. '/navigation.txt',
  keymap = '<leader>cn',
  keymap_desc = '[C]ustom [N]avigation',
  auto_cd = true,
  show_notifications = true,
}

-- Module configuration (will be set by setup)
M.config = {}

function M.setup(options)
  -- Merge user options with defaults
  M.config = vim.tbl_deep_extend('force', defaults, options or {})
  
  -- Initialize the core module with config
  InitializeConfig(M.config)
  
  -- Set up keymap
  SetupKeymap(M.config.keymap, M.config.keymap_desc)
end

-- Export function for programmatic use
M.open_navigation = OpenNavigation

return M
