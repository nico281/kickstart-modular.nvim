return {
  'Fildo7525/pretty_hover',
  event = 'LspAttach',
  opts = {
    border = 'rounded',
    max_width = 80,
    max_height = 20,
    toggle = true,
    focusable = true,
    silent = false,
  },
  keys = {
    {
      'K',
      function()
        require('pretty_hover').hover()
      end,
      desc = 'LSP: Hover documentation',
      mode = 'n',
    },
  },
}
