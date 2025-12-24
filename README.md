# navigation.nvim

A simple Neovim plugin for quick navigation to frequently accessed files and directories from a text file list.

## Features

- **Quick file/directory access** - Navigate to files or directories from a text file list
- **Add current file/directory** - Quickly add the current file or directory to your navigation list
- **Smart directory handling** - Automatically changes working directory when selecting a directory
- **Visual indicators** - Shows `[DIR]` prefix for directories in the selector
- **Netrw integration** - Works with netrw directory buffers 
- **Oil integration** - Works with oil.nvim directory buffers 
- **Configurable** - Customize navigation file path and keymaps
- **Telescope integration** - Works seamlessly with Telescope after directory changes

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'rodolfojsv/navigation.nvim',
  config = function()
    require('navigation').setup({
      nav_file = 'C:/Dev/navigation.txt',  -- Path to your navigation file
      keymap = '<leader>cn',                -- Keymap to trigger navigation
      keymap_desc = '[C]ustom [N]avigation', -- Description for the keymap
    })
  end,
}
```

## Configuration

All options are optional and have sensible defaults:

```lua
require('navigation').setup({
  -- Path to file containing list of files/directories (one per line)
  nav_file = vim.fn.expand('~') .. '/navigation.txt',
  
  -- Keymap to trigger navigation selector
  keymap = '<leader>cn',
  
  -- Description for the keymap (shown in which-key, etc.)
  keymap_desc = '[C]ustom [N]avigation',
  
  -- Keymap to add current file/directory to navigation list
  keymap_add = '<leader>ca',
  
  -- Description for the add keymap
  keymap_add_desc = '[C]ustom [A]dd to navigation',
  
  -- Whether to change working directory when selecting a directory
  auto_cd = true,
  
  -- Whether to show notifications
  show_notifications = true,
})
```

## Usage

### Setup Your Navigation File

Create a text file (e.g., `navigation.txt`) with one file or directory path per line:

```
C:/Dev/myproject/src/main.lua
C:/Dev/myproject/tests/
#### Opening Files/Directories

1. Press your configured keymap (default: `<leader>cn`)
2. A selector will appear showing all files/directories from your navigation file
3. Directories are prefixed with `[DIR]`
4. Select an entry:
   - **For files**: Opens the file in the current buffer
   - **For directories**: Changes working directory and opens in file explorer

#### Adding to Navigation List

1. Open a file or navigate to a directory (including netrw)
2. Press your configured add keymap (default: `<leader>ca`)
3. The current file or directory will be added to your navigation file
4. Duplicates are automatically detected and skipped
5. Notifications will confirm what was added
1. Press your configured keymap (default: `<leader>cn`)
2. A selector will appear showing all files/directories from your navigation file
3. Directories are prefixed with `[DIR]``<leader>cn`)
- `:NavigationAddCwd` - Adds current file or directory to navigation list (same as `<leader>ca`
4. Select an entry:
   - **For files**: Opens the file in the current buffer
   - **For directories**: Changes working directory and opens in file explorer
Quick Adding**: When browsing with netrw or editing a file, press `<leader>ca` to instantly add it to your navigation list
- **Relative vs Absolute Paths**: Use absolute paths in your navigation file for consistency
- **Mixed Content**: Mix files and directories freely in your navigation file
- **Quick Edits**: Add `:e C:/path/to/navigation.txt` to quickly edit your navigation file
- **Smart Detection**: The add command automatically detects if you're in a file, netrw directory, or regular buffer and adds the appropriate path
```
1. Press <leader>cn
2. Select a project directory (e.g., "C:/Dev/myproject/")
3. Directory is changed, notification shows: "Changed directory to: C:/Dev/myproject/"
4. Use Telescope (e.g., <leader>sf) to search files in the new directory
```

## Commands

- `:NavigationOpen` - Opens the navigation selector (same as keymap)

## Tips

- **Telescope Integration**: After changing directories, Telescope searches will automatically use the new directory
- **Relative vs Absolute Paths**: Use absolute paths in your navigation file for consistency
- **Mixed Content**: Mix files and directories freely in your navigation file
- **Quick Edits**: Add `:e C:/path/to/navigation.txt` to quickly edit your navigation file

## Example Keymaps

You can add additional keymaps in your config:

```lua
-- Quick edit navigation file
vim.keymap.set('n', '<leader>en', function()
  vim.cmd('edit ' .. require('navigation').config.nav_file)
end, { desc = '[E]dit [N]avigation file' })

-- Reload config after editing
vim.keymap.set('n', '<leader>rn', function()
  package.loaded['navigation'] = nil
  require('navigation').setup()
  vim.notify('Navigation config reloaded', vim.log.levels.INFO)
end, { desc = '[R]eload [N]avigation config' })
```

## Requirements

- Neovim >= 0.9.0

## License

MIT

## Credits

Created by [Rodolfo Silva](https://github.com/rodolfojsv)
