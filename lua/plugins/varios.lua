return {
  -- Autocerrar y renombrar etiquetas HTML/JSX/TSX
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- Mejores comentarios contextuales en JSX/HTML
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },
  { "uga-rosa/ccc.nvim", opts = {} },
  {
    "ziontee113/icon-picker.nvim",
    config = function()
      require("icon-picker").setup({}) -- ← Agrega los paréntesis con {}
    end,
  },
}
