return {
  'stevearc/oil.nvim',
  lazy = false,
  opts = {
    keymaps = {
      ['`'] = 'actions.parent',
      ['q'] = 'actions.close',
      ['<C-h>'] = false,
      ['<C-l>'] = false,
    },
    view_options = {
      show_hidden = true,
    },
    delete_to_trash = true,
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>we', '<cmd>Oil<cr>', desc = '[W]orkspace [E]xplorer' },
    { '-', '<cmd>Oil<cr>', desc = 'Oil (file explorer)' },
    { '~', '<cmd>Oil ~<cr>', desc = 'Oil Home' },
  },
}
