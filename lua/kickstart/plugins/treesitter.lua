local matchup = require 'custom.plugins.matchup'

local languages = {
  'astro',
  'bash',
  'c',
  'cpp',
  'css',
  'diff',
  'dockerfile',
  'embedded_template',
  'gitignore',
  'go',
  'gomod',
  'gosum',
  'html',
  'ini',
  'javascript',
  'jsdoc',
  'json',
  'json5',
  'lua',
  'luadoc',
  'luap',
  'make',
  'markdown',
  'markdown_inline',
  'printf',
  'python',
  'query',
  'regex',
  'ruby',
  'rust',
  'scss',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'vue',
  'xml',
  'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }

      require('nvim-treesitter').install(languages)
    end,
    dependencies = matchup,
  },
}
-- vim: ts=2 sts=2 sw=2 et
