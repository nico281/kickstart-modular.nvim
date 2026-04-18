local function hover_opts()
  return {
    border = 'rounded',
    max_width = math.max(80, math.min(110, math.floor(vim.o.columns * 0.55))),
    max_height = nil,
    toggle = false,
    focusable = true,
    silent = false,
  }
end

return {
  'Fildo7525/pretty_hover',
  event = 'LspAttach',
  opts = hover_opts,
  keys = {
    {
      'K',
      function()
        require('pretty_hover').setup(hover_opts())
        require('pretty_hover').hover()
      end,
      desc = 'LSP: Hover documentation',
      mode = 'n',
    },
  },
}
