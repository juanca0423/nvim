return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      term_colors = true,
      custom_highlights = function(colors)
        return {
          CursorLineNr = { fg = colors.peach, bold = true },
          LineNr = { fg = colors.yellow },
          FoldColumn = { fg = colors.blue, bold = true },
          SignColumn = { bg = "none" },

          -- ✅ Grupo dedicado para el símbolo showbreak "↳" (sin romper NonText) colors.peach, colors.yellow, colors.green, colors.sapphire, colors.mauve, o colors.flamingo.
          CatppuccinShowBreak = { fg = colors.green, bold = true },

          -- ✅ Colores del Dashboard de Snacks.nvim
          SnacksDashboardKey = { fg = colors.red, bold = true },
          SnacksDashboardDesc = { fg = colors.subtext1 },
          SnacksDashboardHeader = { fg = colors.blue },
          SnacksDashboardFooter = { fg = colors.yellow },

          -- Botones individuales del Dashboard
          DashboardC = { fg = colors.sky },
          DashboardG = { fg = colors.green },
          DashboardY = { fg = colors.yellow },
          DashboardP = { fg = colors.mauve },
          DashboardO = { fg = colors.peach },
          DashboardB = { fg = colors.blue },
          DashboardR = { fg = colors.red },
        }
      end,
      integrations = {
        snacks = true,
        bufferline = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        native_lsp = { enabled = true },
        render_markdown = true,
      },
    })

    -- 🚀 LÍNEA CRÍTICA: Activa Catppuccin explícitamente en Neovim
    vim.cmd.colorscheme("catppuccin")
  end,
}
