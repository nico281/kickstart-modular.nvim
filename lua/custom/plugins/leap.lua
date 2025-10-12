return {
  'ggandor/leap.nvim',
  event = 'VeryLazy',
  config = function()
    local leap = require('leap')
    
    -- Configure leap
    leap.setup({
      max_phase_one_targets = nil,
      highlight_unlabeled_phase_one_targets = false,
      max_highlighted_traversal_targets = 10,
      case_sensitive = false,
      equivalence_classes = { ' \t\r\n' },
      substitute_chars = {},
      safe_labels = 'sfnut/SFNLHMUGTZ?',
      labels = 'sfnjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?',
      special_keys = {
        repeat_search = '<enter>',
        next_phase_one_target = '<enter>',
        next_target = { '<enter>', ';' },
        prev_target = { '<tab>', ',' },
        next_group = '<space>',
        prev_group = '<tab>',
        multi_accept = '<enter>',
        multi_revert = '<backspace>',
      },
    })

    -- Set up keymaps
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.silent = opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Bidirectional search in the current window
    map({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)', { desc = 'Leap forward' })
    map({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)', { desc = 'Leap backward' })
    
    -- Search in other windows
    map({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)', { desc = 'Leap from window' })

    -- Linewise motions (optional, uncomment if you want them)
    -- map({ 'n', 'x', 'o' }, 'gl', '<Plug>(leap-line-forward)', { desc = 'Leap line forward' })
    -- map({ 'n', 'x', 'o' }, 'gL', '<Plug>(leap-line-backward)', { desc = 'Leap line backward' })

    -- Set custom highlight groups
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        -- Customize leap highlight colors
        vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = '#777777' })
        vim.api.nvim_set_hl(0, 'LeapMatch', {
          fg = 'white',
          bg = '#ff007c',
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
          fg = 'black',
          bg = '#ff007c',
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'LeapLabelSecondary', {
          fg = 'white',
          bg = '#0080ff',
          bold = true,
        })
        vim.api.nvim_set_hl(0, 'LeapLabelSelected', {
          fg = 'white',
          bg = '#ff7700',
          bold = true,
        })
      end,
    })
    
    -- Trigger the autocmd for the current colorscheme
    vim.cmd('doautocmd ColorScheme')

    -- Optional: Add repeat functionality with dot (.)
    -- This allows you to repeat the last leap motion with '.'
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LeapEnter',
      callback = function()
        vim.cmd('echohl WarningMsg | echo "Leap mode" | echohl None')
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LeapLeave',
      callback = function()
        vim.cmd('echo ""')
      end,
    })

    -- Alternative keymaps (uncomment if you prefer these)
    -- Use 'f' and 'F' for leap instead of default find
    -- map({ 'n', 'x', 'o' }, 'f', '<Plug>(leap-forward-to)', { desc = 'Leap forward to' })
    -- map({ 'n', 'x', 'o' }, 'F', '<Plug>(leap-backward-to)', { desc = 'Leap backward to' })
    -- map({ 'n', 'x', 'o' }, 't', '<Plug>(leap-forward-till)', { desc = 'Leap forward till' })
    -- map({ 'n', 'x', 'o' }, 'T', '<Plug>(leap-backward-till)', { desc = 'Leap backward till' })
  end,
  dependencies = {
    -- Optional: flit.nvim for enhanced f/t motions
    -- {
    --   'ggandor/flit.nvim',
    --   config = function()
    --     require('flit').setup({
    --       keys = { f = 'f', F = 'F', t = 't', T = 'T' },
    --       labeled_modes = "v",
    --       multiline = true,
    --       opts = {}
    --     })
    --   end
    -- }
  }
}