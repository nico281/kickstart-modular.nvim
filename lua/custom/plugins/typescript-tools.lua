return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    settings = {
      expose_as_code_action = 'all',
      tsserver_plugins = {},
      tsserver_format_options = {
        allowIncompleteCompletions = true,
        allowRenameOfImportPath = true,
      },
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayVariableTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
      },
    },
  },
}
