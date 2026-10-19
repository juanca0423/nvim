return {
  "akinsho/bufferline.nvim",
  optional = true,
  opts = function(_, opts)
    if (vim.g.colors_name or ""):find("catppuccin") then
      opts.highlights = require("catppuccin.special.bufferline").get_theme()
    end
  end,
  options = {
    mode = "buffers",
    -- Cambiamos esto por la forma nativa que usa nvim-web-devicons
    show_buffer_icons = true,

    -- ELIMINAMOS get_element_icon para que use el default que sí funciona
    -- Bufferline ya sabe buscar los iconos si tienes nvim-web-devicons instalado

    separator_style = "slant",
    show_buffer_close_icons = true,
    show_close_icon = false,
    diagnostics = "nvim_lsp",

    offsets = {
      {
        filetype = "snacks_explorer",
        text = " EXPLORADOR ",
        text_align = "left",
        separator = true,
      },
    },

    custom_filter = function(buf_number)
      local ft = vim.bo[buf_number].filetype
      local exclude = {
        ["alpha"] = true,
        ["dashboard"] = true,
        ["snacks_dashboard"] = true,
        ["yanky"] = true,
        ["lazy"] = true,
      }
      return not exclude[ft]
    end,
  },
}
