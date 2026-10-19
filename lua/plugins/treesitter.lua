-- lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = function(_, opts)
    -- Ajustes para compilación en Termux
    pcall(function()
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.install").compilers = { "clang" }
    end)

    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "glimmer",
      "glimmer_javascript",
      "handlebars",
      "lua",
      "go",
      "json",
    })

    opts.highlight = opts.highlight or {}
    opts.highlight.enable = true

    opts.indent = opts.indent or {}
    opts.indent.enable = true

    return opts
  end,
  config = function(_, opts)
    -- En versiones recientes de LazyVim / nvim-treesitter,
    -- la inicialización la gestiona el plugin internamente.
    -- Para mantener compatibilidad con versiones previas y nuevas de forma segura:
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if ok and configs then
      configs.setup(opts)
    end

    -- Asignación de alias para Handlebars
    vim.treesitter.language.register("glimmer", "handlebars")
    vim.treesitter.language.register("glimmer", "hbs")
    vim.treesitter.language.register("html", "handlebars")
  end,
}
