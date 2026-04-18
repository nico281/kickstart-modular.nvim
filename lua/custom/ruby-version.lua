-- Detect Ruby version from mise and update PATH
-- Works on macOS, Linux, and WSL
-- This file is sourced directly, not a lazy.nvim plugin

local env = require 'custom.env'

local mise_bin = env.find_mise()

-- Check if mise is available
local function has_mise()
  return mise_bin ~= nil
end

local function warn_missing_mise()
  vim.notify_once('mise requerido para Ruby/Rails en Neovim', vim.log.levels.WARN, { title = 'Ruby' })
end

local function get_ruby_path()
  if has_mise() then
    local mise_path = env.mise_which 'ruby'
    if vim.fn.executable(mise_path) == 1 then
      local mise_prefix = env.mise_where 'ruby'
      return mise_path, mise_prefix, 'mise'
    end
  end

  return nil, nil, 'none'
end

local function is_ruby_project()
  return vim.fn.filereadable(vim.fn.getcwd() .. '/.ruby-version') == 1
    or vim.fn.filereadable(vim.fn.getcwd() .. '/.mise.toml') == 1
    or vim.fn.filereadable(vim.fn.getcwd() .. '/Gemfile') == 1
end

local function update_path_for_ruby()
  local ruby_path, ruby_prefix = get_ruby_path()

  if ruby_path and ruby_path ~= '' and ruby_path ~= 'ruby' then
    -- Extract bin directory from ruby path
    local ruby_bin = vim.fn.fnamemodify(ruby_path, ':h')

    -- Always move the project Ruby to the front, even if it already exists later in PATH.
    env.prepend_path(ruby_bin)

    -- Add gem bin paths if available.
    if ruby_prefix and ruby_prefix ~= '' then
      env.prepend_path(ruby_prefix .. '/bin')
    end

    return ruby_path
  end

  if is_ruby_project() or vim.bo.filetype == 'ruby' then
    warn_missing_mise()
  end

  return nil
end

update_path_for_ruby()

-- Create augroup
local ruby_version_group = vim.api.nvim_create_augroup('ruby_version', { clear = true })

-- Update PATH when entering Ruby files or projects
vim.api.nvim_create_autocmd({ 'BufEnter', 'DirChanged' }, {
  group = ruby_version_group,
  callback = function()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand('%:t')

    -- Check if we're in a Ruby project or file
    if is_ruby_project() or filetype == 'ruby' or filename == 'Gemfile' or filename == 'Rakefile' or filename == '.ruby-version' or filename == '.mise.toml' then
      update_path_for_ruby()
    end
  end,
  desc = 'Detect Ruby version and update PATH',
})

-- Manual command to reload Ruby version
vim.api.nvim_create_user_command('RubyReload', function()
  update_path_for_ruby()
  -- Restart ruby_lsp if it's running
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name == 'ruby_lsp' then
      vim.cmd('LspRestart')
      break
    end
  end
end, { desc = 'Reload Ruby version and restart LSP' })

-- Command to show current Ruby info
vim.api.nvim_create_user_command('RubyInfo', function()
  local ruby_path, _, manager = get_ruby_path()
  if ruby_path and ruby_path ~= '' then
    local bundle_path = env.mise_which 'bundle'
    local info = {
      'Manager: ' .. manager,
      'Path: ' .. ruby_path,
      'Version: ' .. vim.fn.trim(vim.fn.system(ruby_path .. ' --version')),
      'Bundle: ' .. (bundle_path and vim.fn.trim(vim.fn.system(bundle_path .. ' --version')) or 'not found via mise'),
    }
    vim.notify(table.concat(info, '\n'), vim.log.levels.INFO, { title = 'Ruby Info' })
  else
    vim.notify('No Ruby via mise', vim.log.levels.WARN, { title = 'Ruby Info' })
  end
end, { desc = 'Show current Ruby information' })
