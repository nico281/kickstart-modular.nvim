return {
  'sindrets/diffview.nvim',
  config = function()
    vim.keymap.set('n', '<leader>dv', '<cmd>DiffviewOpen<cr>', { desc = '[D]iff[V]iew open' })
    vim.keymap.set('n', '<leader>dvc', '<cmd>DiffviewClose<cr>', { desc = '[D]iff[V]iew close' })
    vim.keymap.set('n', '<leader>dvs', '<cmd>DiffviewFileHistory<cr>', { desc = '[D]iff[V]iew file history' })
    vim.keymap.set('n', '<leader>dvr', '<cmd>DiffviewRefresh<cr>', { desc = '[D]iff[V]iew refresh' })
  end,
}
