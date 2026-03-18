return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    input = { enabled = true },
    scroll = { enabled = true },
    zen = { enabled = true },
  },
  keys = {
    { '<leader>z', function() Snacks.zen() end, desc = 'Zen Mode' },
  },
}
