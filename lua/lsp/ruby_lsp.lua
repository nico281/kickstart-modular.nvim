local function find_mise()
  local candidates = {
    vim.fn.expand '~' .. '/.local/bin/mise',
    '/opt/homebrew/bin/mise',
    '/usr/local/bin/mise',
  }
  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return nil
end

local mise_bin = find_mise()

local function get_ruby_path()
  -- Try mise first (use absolute path to avoid shell PATH issues)
  if mise_bin then
    local mise_path = vim.fn.trim(vim.fn.system(mise_bin .. ' which ruby 2>/dev/null'))
    if vim.fn.executable(mise_path) == 1 then
      return mise_path
    end
  end

  -- Try rbenv
  if vim.fn.executable('rbenv') == 1 then
    local rbenv_path = vim.fn.trim(vim.fn.system('rbenv which ruby 2>/dev/null'))
    if vim.fn.executable(rbenv_path) == 1 then
      return rbenv_path
    end
  end

  -- Try asdf
  if vim.fn.executable('asdf') == 1 then
    local asdf_path = vim.fn.trim(vim.fn.system('asdf which ruby 2>/dev/null'))
    if vim.fn.executable(asdf_path) == 1 then
      return asdf_path
    end
  end

  -- Fallback to system ruby
  local system_ruby = vim.fn.trim(vim.fn.system('which ruby 2>/dev/null'))
  if vim.fn.executable(system_ruby) == 1 then
    return system_ruby
  end

  return nil
end

local ruby_path = get_ruby_path()

if ruby_path then
  return {
    cmd = { ruby_path, '-S', 'bundle', 'exec', 'ruby-lsp' },
    init_options = {
      enabledFeatures = {
        diagnostics = false, -- use nvim-lint with bundled rubocop instead
      },
    },
  }
else
  -- Fallback to bundle exec
  return {
    cmd = { 'bundle', 'exec', 'ruby-lsp' },
    init_options = {
      enabledFeatures = {
        diagnostics = false,
      },
    },
  }
end
