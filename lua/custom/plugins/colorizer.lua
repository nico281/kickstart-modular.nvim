return {
  'catgoose/nvim-colorizer.lua',
  event = 'VeryLazy',
  opts = { -- set to setup table
    lazy_load = true,
  },
  config = function()
    require('colorizer').setup {
      filetypes = { '*' }, -- or limit to specific ones like { "html", "tsx", "svelte", "css" }
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        css = true,
        css_fn = true,
        mode = 'background', -- or "virtualtext"
        tailwind = true, -- ✅ enables Tailwind class color support
      },
    }
  end,
}
