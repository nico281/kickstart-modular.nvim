return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig', 'saghen/blink.cmp' },
  opts = function()
    return {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      settings = {
        expose_as_code_action = 'all',
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayVariableTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
      },
    }
  end,
  keys = {
    { '<leader>ci', '<cmd>TSToolsAddMissingImports<cr>', desc = 'Add Missing [I]mports' },
    { '<leader>co', '<cmd>TSToolsOrganizeImports<cr>', desc = '[O]rganize Imports' },
    { '<leader>cu', '<cmd>TSToolsRemoveUnused<cr>', desc = 'Remove [U]nused' },
    { '<leader>cF', '<cmd>TSToolsFixAll<cr>', desc = '[F]ix All' },
  },
}
