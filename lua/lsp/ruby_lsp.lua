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

--- Resolve the full path to a Ruby gem executable using version managers.
--- Uses `mise which` / `rbenv which` / `asdf which` to avoid picking up
--- binary shims that `ruby -S` cannot execute.
local function resolve_gem_exe(name)
  if mise_bin then
    local p = vim.fn.trim(vim.fn.system(mise_bin .. ' which ' .. name .. ' 2>/dev/null'))
    if vim.fn.executable(p) == 1 then
      return p
    end
  end

  if vim.fn.executable('rbenv') == 1 then
    local p = vim.fn.trim(vim.fn.system('rbenv which ' .. name .. ' 2>/dev/null'))
    if vim.fn.executable(p) == 1 then
      return p
    end
  end

  if vim.fn.executable('asdf') == 1 then
    local p = vim.fn.trim(vim.fn.system('asdf which ' .. name .. ' 2>/dev/null'))
    if vim.fn.executable(p) == 1 then
      return p
    end
  end

  return nil
end

-- Resolve ruby-lsp directly so we skip mise's binary shims
-- (ruby -S finds the shim and tries to load it as Ruby code, which fails).
local ruby_lsp_path = resolve_gem_exe('ruby-lsp')

if ruby_lsp_path then
  return {
    cmd = { ruby_lsp_path },
    init_options = {
      enabledFeatures = {
        diagnostics = false, -- use nvim-lint with bundled rubocop instead
      },
    },
  }
else
  return {
    cmd = { 'ruby-lsp' },
    init_options = {
      enabledFeatures = {
        diagnostics = false,
      },
    },
  }
end
