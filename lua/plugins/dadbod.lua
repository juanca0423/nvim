return {
  {
    "tpope/vim-dadbod",
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      {
        "tpope/vim-dadbod",
        lazy = false,
      },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUI",
      "DBUIFindBuffer",
      "DBUIRenameBuffer",
      "DBUILastQueryInfo",
    },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Alternar UI de base de datos" },
      {
        "<leader>ds",
        "<plug>(DBUI_ExecuteQuery)",
        mode = { "n", "v" },
        desc = "DBUI_ExecuteQueryr Query SQL",
      },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_datavase_navigation = 1
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_save_queries = 1
    end,
  },
}
