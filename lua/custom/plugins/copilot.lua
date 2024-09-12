return {
  'zbirenbaum/copilot.lua',
  config = function()
    require('copilot').setup {}
    vim.keymap.set('i', '<C-l>', function()
      vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')
    end, { desc = 'Copilot Enter' })
  end,
  cmd = 'Copilot',
  event = 'InsertEnter',
  lazy = true,
  enable = false,
}
