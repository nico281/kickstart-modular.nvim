local env = require 'custom.env'

--- Resolve the full path to a Ruby gem executable using version managers.
local function resolve_gem_exe(name)
  return env.mise_which(name)
end

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
  vim.notify_once('ruby_lsp desactivado: mise no resolvio ruby-lsp', vim.log.levels.WARN, { title = 'Ruby LSP' })
  return nil
end
