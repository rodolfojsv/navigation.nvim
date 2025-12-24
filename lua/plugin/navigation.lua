-- plugin/navigation.lua
-- User commands and keymaps

-- Create user commands
vim.api.nvim_create_user_command('NavigationOpen', OpenNavigation, {})
vim.api.nvim_create_user_command('NavigationAddCwd', AddCurrentDirectoryToNav, {})

-- Function to set up keymap (called by init.lua after config is loaded)
function SetupKeymap(keymap, keymap_desc)
  vim.keymap.set('n', keymap, OpenNavigation, { desc = keymap_desc })
end

-- Function to set up keymap for adding current directory
function SetupAddKeymap(keymap, keymap_desc)
  vim.keymap.set('n', keymap, AddCurrentDirectoryToNav, { desc = keymap_desc })
end
