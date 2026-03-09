return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    dashboard = { enabled = true },
    input = { enabled = true }, -- inputs modales
    scroll = { enabled = true }, -- smooth scroll
    zen = { enabled = true },
  },
  keys = {
    { '<leader>z', function() Snacks.zen() end, desc = 'Zen Mode' },
    { '<leader>d', function() Snacks.dashboard() end, desc = 'Dashboard' },
  },
}
