-- lua/plugins/colors.lua

return {
  "NvChad/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    filetypes = { "*" },
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      RRGGBBAA = true,
      names = true,
      css = true,
      mode = "virtualtext", -- ← solo símbolo virtual
      virtualtext = "■", -- ← el cuadrito
      virtualtext_inline = false, -- ← no inline con el texto
      virtualtext_mode = "eol", -- ← al final de línea
    },
  },
}

-- return {
--   "brenoprata10/nvim-highlight-colors",
--   event = "BufReadPre",
--   opts = {
--     render = "virtual",
--     virtual_symbol = "■",              -- ← corregido y símbolo coloreable
--     virtual_symbol_position = "eol",   -- ← corregido
--     virtual_symbol_prefix = " ",       -- espacio antes del cuadrito
--     virtual_symbol_suffix = "",
--     enable_named_colors = true,
--     enable_tailwind = true,
--   },
-- }
