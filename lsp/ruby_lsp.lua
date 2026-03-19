return {
  cmd = { 'bundle', 'exec', 'ruby-lsp' },
  init_options = {
    enabledFeatures = {
      diagnostics = false, -- use nvim-lint with bundled rubocop instead
    },
  },
}
