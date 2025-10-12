return {
  'whiteinge/diffconflicts',
  config = function()
    -- Enable diffconflicts by default when opening files with conflict markers
    vim.g.DiffConflictsAutostart = 1

    -- Set up keymaps for diff conflict resolution
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.silent = opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Keymaps for when in diffconflicts mode
    -- These will only be active when resolving conflicts
    vim.api.nvim_create_autocmd('User', {
      pattern = 'DiffConflictsStart',
      callback = function()
        local opts = { buffer = true, desc = 'Diff Conflicts' }
        -- Use left side (LOCAL)
        map('n', '<leader>co', '<Plug>DiffConflictsObtain',
          vim.tbl_extend('force', opts, { desc = 'Use LOCAL (current branch)' }))
        -- Use right side (REMOTE)
        map('n', '<leader>cp', '<Plug>DiffConflictsPut',
          vim.tbl_extend('force', opts, { desc = 'Use REMOTE (incoming branch)' }))
        -- Navigate between conflicts
        map('n', '[x', '[c', vim.tbl_extend('force', opts, { desc = 'Previous conflict' }))
        map('n', ']x', ']c', vim.tbl_extend('force', opts, { desc = 'Next conflict' }))
        -- Quit diffconflicts
        map('n', '<leader>dq', ':DiffConflictsClose<CR>',
          vim.tbl_extend('force', opts, { desc = 'Close diff conflicts' }))
      end,
    })

    -- Note: DiffConflicts command is provided by the plugin itself
    -- No need to create our own command
  end,

  -- Only load when we have git conflicts
  cond = function()
    return vim.fn.executable 'git' == 1
  end,
}
