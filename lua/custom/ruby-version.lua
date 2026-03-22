-- Detect Ruby version from mise/rbenv/asdf and update PATH
-- Works on macOS, Linux, and WSL
-- This file is sourced directly, not a lazy.nvim plugin

local path_sep = vim.fn.has('win32') == 1 and ';' or ':'

-- Check if mise is available
local function has_mise()
  return vim.fn.executable('mise') == 1
end

local function get_ruby_path()
  -- Priority: mise > rbenv > asdf > system

  -- Try mise (includes ~/.config/mise/config.toml)
  if has_mise() then
    local mise_path = vim.fn.trim(vim.fn.system('mise exec ruby -- which ruby 2>/dev/null'))
    if vim.fn.executable(mise_path) == 1 then
      local mise_prefix = vim.fn.trim(vim.fn.system('mise where ruby 2>/dev/null'))
      return mise_path, mise_prefix, 'mise'
    end
  end

  -- Try rbenv
  if vim.fn.executable('rbenv') == 1 then
    local rbenv_path = vim.fn.trim(vim.fn.system('rbenv which ruby 2>/dev/null'))
    if vim.fn.executable(rbenv_path) == 1 then
      local rbenv_prefix = vim.fn.trim(vim.fn.system('rbenv prefix 2>/dev/null'))
      return rbenv_path, rbenv_prefix, 'rbenv'
    end
  end

  -- Try asdf
  if vim.fn.executable('asdf') == 1 then
    local asdf_path = vim.fn.trim(vim.fn.system('asdf which ruby 2>/dev/null'))
    if vim.fn.executable(asdf_path) == 1 then
      return asdf_path, nil, 'asdf'
    end
  end

  -- Fallback to system ruby
  local system_ruby = vim.fn.trim(vim.fn.system('which ruby 2>/dev/null'))
  if vim.fn.executable(system_ruby) == 1 then
    return system_ruby, nil, 'system'
  end

  return nil, nil, 'none'
end

local function update_path_for_ruby()
  local ruby_path, ruby_prefix, manager = get_ruby_path()

  if ruby_path and ruby_path ~= '' and ruby_path ~= 'ruby' then
    -- Extract bin directory from ruby path
    local ruby_bin = vim.fn.fnamemodify(ruby_path, ':h')

    -- Get current PATH
    local current_path = vim.env.PATH or ''

    -- Only update if not already in PATH
    if not current_path:match(vim.pesc(ruby_bin)) then
      vim.env.PATH = ruby_bin .. path_sep .. current_path

      -- Add gem bin paths if available
      if ruby_prefix and ruby_prefix ~= '' then
        local gem_bin = ruby_prefix .. '/bin'
        if not vim.env.PATH:match(vim.pesc(gem_bin)) then
          vim.env.PATH = gem_bin .. path_sep .. vim.env.PATH
        end
      end

      vim.notify(
        string.format('Ruby (%s): %s', manager, vim.fn.trim(vim.fn.system(ruby_path .. ' --version'))),
        vim.log.levels.INFO,
        { title = 'Ruby Version' }
      )
    else
      -- Still show which ruby we're using
      local version = vim.fn.trim(vim.fn.system(ruby_path .. ' --version'))
      vim.notify(string.format('Ruby (%s): %s', manager, version), vim.log.levels.DEBUG, { title = 'Ruby Version' })
    end

    return ruby_path
  end

  vim.notify('No Ruby found', vim.log.levels.WARN, { title = 'Ruby Version' })
  return nil
end

-- Create augroup
local ruby_version_group = vim.api.nvim_create_augroup('ruby_version', { clear = true })

-- Update PATH when entering Ruby files or projects
vim.api.nvim_create_autocmd({ 'BufEnter', 'DirChanged' }, {
  group = ruby_version_group,
  callback = function()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand('%:t')

    -- Check if we're in a Ruby project or file
    if filetype == 'ruby' or filename == 'Gemfile' or filename == 'Rakefile' or filename == '.ruby-version' or filename == '.mise.toml' then
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
    local info = {
      'Manager: ' .. manager,
      'Path: ' .. ruby_path,
      'Version: ' .. vim.fn.trim(vim.fn.system(ruby_path .. ' --version')),
      'Bundle: ' .. (vim.fn.executable('bundle') == 1 and vim.fn.trim(vim.fn.system('bundle --version')) or 'not found'),
    }
    vim.notify(table.concat(info, '\n'), vim.log.levels.INFO, { title = 'Ruby Info' })
  else
    vim.notify('No Ruby detected', vim.log.levels.WARN, { title = 'Ruby Info' })
  end
end, { desc = 'Show current Ruby information' })
