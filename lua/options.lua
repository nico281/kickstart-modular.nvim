-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
vim.opt.fileformat = 'unix'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.relativenumber = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Ensure mise/nvm are first in PATH (needed for Neovide/WSL without login shell)
do
  local env = require 'custom.env'
  local home = vim.fn.expand '~'
  local prepend = {}

  -- mise bin (mise binary itself)
  local mise_bin = vim.fs.joinpath(home, '.local', 'bin')
  if vim.fn.isdirectory(mise_bin) == 1 then
    table.insert(prepend, mise_bin)
  end

  -- mise shims (ruby, node, etc)
  local mise_shims = vim.fs.joinpath(home, '.local', 'share', 'mise', 'shims')
  if vim.fn.isdirectory(mise_shims) == 1 then
    table.insert(prepend, mise_shims)
  end

  -- nvm
  local nvm_bins = vim.fn.glob(vim.fs.joinpath(home, '.nvm', 'versions', 'node', '*', 'bin'), false, true)
  table.sort(nvm_bins)
  if #nvm_bins > 0 then
    table.insert(prepend, nvm_bins[#nvm_bins])
  end

  -- linuxbrew (rg, fd, etc. for Neovide/WSL without login shell)
  local linuxbrew_bin = '/home/linuxbrew/.linuxbrew/bin'
  if vim.fn.isdirectory(linuxbrew_bin) == 1 then
    table.insert(prepend, linuxbrew_bin)
  end

  env.prepend_path(prepend)
end

if vim.g.neovide then
  local uname = vim.uv.os_uname()
  local is_macos = uname.sysname == 'Darwin'
  local is_wsl = uname.release:lower():find('microsoft', 1, true) ~= nil
  local font_size = (vim.fn.has 'win32' == 1 or is_wsl) and 13 or 19

  --vim.o.guifont = 'IosevkaTerm Nerd Font Mono:h18'
  -- vim.o.guifont = ('Maple Mono NF:h%d'):format(font_size)
  vim.o.guifont = ([[DankMono\ Nerd\ Font\ Mono:h%d]]):format(font_size)
  --vim.o.guifont = 'Recursive:h22'
  vim.opt.linespace = 8

  vim.g.neovide_refresh_rate = 120
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_hide_mouse_when_typing = true

  vim.g.neovide_scroll_animation_length = 0.12
  vim.g.neovide_cursor_animation_length = 0.15 -- duration in seconds
  vim.g.neovide_cursor_trail_size = 0.3        -- 0.0 = no trail, 1.0 = instant jump
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true

  if is_macos then
    vim.g.neovide_input_use_logo = true
    vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
  end

  local function change_scale(delta)
    vim.g.neovide_scale_factor = math.max(0.5, (vim.g.neovide_scale_factor or 1) + delta)
  end

  vim.keymap.set('n', '<D-=>', function() change_scale(0.1) end, { desc = 'Neovide zoom in' })
  vim.keymap.set('n', '<D-->', function() change_scale(-0.1) end, { desc = 'Neovide zoom out' })
  vim.keymap.set('n', '<D-0>', function() vim.g.neovide_scale_factor = 1 end, { desc = 'Neovide zoom reset' })
  vim.keymap.set('n', '<D-CR>', function() vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen end, { desc = 'Neovide fullscreen' })
end

-- vim: ts=2 sts=2 sw=2 et
