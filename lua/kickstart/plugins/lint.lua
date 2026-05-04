-- Linting

---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      markdown = { 'markdownlint' }, -- Make sure to install `markdownlint` via mason / npm
      ruby = { 'rubocop' },
    }

    -- Use bundled rubocop
    lint.linters.rubocop = {
      cmd = 'bundle',
      args = { 'exec', 'rubocop', '--format', 'json', '--force-exclusion', '--stdin', function() return vim.fn.expand '%:p' end },
      stdin = true,
      stream = 'stdout',
      ignore_exitcode = true,
      parser = function(output)
        local diagnostics = {}
        local ok, decoded = pcall(vim.json.decode, output)
        if not ok or not decoded or not decoded.files then
          return diagnostics
        end
        for _, file in ipairs(decoded.files) do
          for _, offense in ipairs(file.offenses or {}) do
            table.insert(diagnostics, {
              lnum = offense.location.start_line - 1,
              col = offense.location.start_column - 1,
              end_lnum = offense.location.last_line - 1,
              end_col = offense.location.last_column,
              severity = offense.severity == 'error' and vim.diagnostic.severity.ERROR
                or offense.severity == 'warning' and vim.diagnostic.severity.WARN
                or vim.diagnostic.severity.INFO,
              message = offense.message,
              source = 'rubocop',
              code = offense.cop_name,
            })
          end
        end
        return diagnostics
      end,
    }

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in buffers that you can modify in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.bo.modifiable then lint.try_lint() end
      end,
    })
  end,
}
