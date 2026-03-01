return {
  'kevinhwang91/nvim-ufo',
  dependencies = { 'kevinhwang91/promise-async' },
  event = 'VeryLazy',
  opts = {
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' 󰁂 %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local truncated = truncate(width - vim.fn.strdisplaywidth(suffix))

      for _, chunk in ipairs(virtText) do
        if truncated > 0 then
          if chunk[1] and vim.fn.strdisplaywidth(chunk[1]) > truncated then
            table.insert(newVirtText, { vim.fn.strpart(chunk[1], 0, truncated), chunk[2] })
            truncated = 0
          else
            table.insert(newVirtText, chunk)
            truncated = truncated - (chunk[1] and vim.fn.strdisplaywidth(chunk[1]) or 0)
          end
        end
      end

      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end,
  },
  config = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
}
