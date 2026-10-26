-- lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
      "javascript",
      "typescript",
      "tsx",
      "html",
      "go",
      "lua",
      "bash",
      "json",
      -- Puedes dejar aquí los que ya tengas por defecto en LazyVim
      "vim",
      "vimdoc",
      "query",
      "lua",
      "python",
      "regex",
      "yaml",
    })

    opts.highlight = opts.highlight or {}
    opts.highlight.enable = true

    opts.indent = opts.indent or {}
    opts.indent.enable = true

    -- Asignación de alias para Handlebars
    vim.treesitter.language.register("glimmer", "handlebars")
    vim.treesitter.language.register("glimmer", "hbs")

    return opts
  end,
}
