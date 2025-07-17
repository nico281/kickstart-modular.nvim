return {
  'SmiteshP/nvim-navic',
  requires = 'neovim/nvim-lspconfig',
  lazy = true,
  event = 'LspAttach',
  config = function()
    local function set_highlights()
      local hl = vim.api.nvim_set_hl
      hl(0, 'NavicText', { fg = '#ffffff' })
      hl(0, 'NavicSeparator', { fg = '#888888' })
    end
    set_highlights()
  end,
}
