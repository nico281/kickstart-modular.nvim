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
          title = ' Search',
          win = { style = { border = 'rounded' } },
        }, function(text)
          if text and text ~= '' then
            vim.fn.setreg('/', text)
            vim.fn.histadd('search', text)
            vim.opt.hlsearch = true
            -- Buscar la primera ocurrencia
            vim.fn.search(text, 'W')
          end
        end)
      end,
      mode = 'n',
      desc = 'Search',
    },
    -- Command modal (LazyVim style)
    {
      ':',
      function()
        Snacks.input({
          prompt = 'Command: ',
          win = {
            style = { border = 'rounded' },
            title = ' Command',
            title_pos = 'center',
          },
        }, function(text)
          if text and text ~= '' then
            vim.fn.histadd('cmd', text)
            vim.cmd(text)
          end
        end)
      end,
      mode = 'n',
      desc = 'Command',
    },
  },
}
