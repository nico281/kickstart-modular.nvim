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
    -- Search modal (LazyVim style)
    {
      '/',
      function()
        Snacks.input({
          prompt = 'Search: ',
          win = { style = { border = 'rounded' } },
        }, function(text)
          if text then
            vim.fn.setreg('/', text)
            vim.fn.histadd('search', text)
            vim.cmd('normal! /' .. text)
          end
        end)
      end,
      mode = 'n',
      desc = 'Search',
    },
  },
}
