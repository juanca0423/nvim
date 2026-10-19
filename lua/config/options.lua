-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ","
vim.g.loaded_perl_provider = 0
vim.g.autoformat = true

-- lua/config/options.lua

-- 1. Registrar extensiones personalizadas (Handlebars y Pug/Jade)
-- (jsx y tsx ya vienen,xx configurados por defecto en Neovim)
vim.filetype.add({
  extension = {
    hbs = "handlebars",
    handlebars = "handlebars",
    pug = "pug",
    jade = "pug",
  },
})

-- 2. Registrar aliases de Treesitter para lenguajes personalizados
vim.treesitter.language.register("glimmer", "handlebars")
vim.treesitter.language.register("pug", "pug")

-- 3. Configuración global de diagnósticos
local icons = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }

vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.Error,
      [vim.diagnostic.severity.WARN] = icons.Warn,
      [vim.diagnostic.severity.HINT] = icons.Hint,
      [vim.diagnostic.severity.INFO] = icons.Info,
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    focusable = false,
  },
})

-- ~/.config/nvim/lua/config/options.lua
vim.g.conform_formatters_disable = {
  "fish_indent",
  "markdown-toc",
  "markdownlint-cli2",
  "sqlfluff",
}
