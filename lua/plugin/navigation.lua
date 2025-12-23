-- plugin/navigation.lua
-- User commands and keymaps

-- Create user command
vim.api.nvim_create_user_command('NavigationOpen', OpenNavigation, {})

-- Function to set up keymap (called by init.lua after config is loaded)
function SetupKeymap(keymap, keymap_desc)
  vim.keymap.set('n', keymap, OpenNavigation, { desc = keymap_desc })
end
