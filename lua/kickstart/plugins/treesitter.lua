local matchup = require 'custom.plugins.matchup'
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.config').setup {}
    end,
    dependencies = matchup,
  },
}
-- vim: ts=2 sts=2 sw=2 et
