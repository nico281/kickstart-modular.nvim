return {
  'gbprod/yanky.nvim',
  lazy = false,
  priority = 100,
  config = function()
    require('yanky').setup {
      ring = {
        history_length = 100,
        storage = 'shada',
      },
    }
    vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
    vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
    vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
    vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
    vim.keymap.set('n', '<leader>p', '<cmd>YankyRingHistory<cr>', { desc = 'Yank history' })
  end,
}
