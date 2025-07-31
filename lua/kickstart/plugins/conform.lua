return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        local disable_filetypes = { c = true, cpp = true }
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        if disable_filetypes[ft] then
          return nil
        end

        local conform = require 'conform'
        local formatters = conform.list_formatters_for_buffer(bufnr)
        local is_rubocop = false

        for _, name in ipairs(formatters) do
          if name == 'rubocop' then
            is_rubocop = true
            break
          end
        end

        return {
          timeout_ms = is_rubocop and 5000 or 500,
          lsp_fallback = 'always',
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        astro = { 'prettier' },
        ruby = { 'rubocop', '--auto-correct-all', '--only-fix' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { 'prettier', 'prettierd', stop_after_first = true },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
