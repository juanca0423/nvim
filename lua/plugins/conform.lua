-- lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- Web con biome
    local web_ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "json",
      "jsonc",
      "css",
      "scss",
      "vue",
      "svelte",
      "graphql",
      "astro",
    }
    for _, ft in ipairs(web_ft) do
      opts.formatters_by_ft[ft] = { "biome" }
    end

    -- Go
    opts.formatters_by_ft.go = { "goimports", "gofmt" }

    -- Markdown: Usar SOLO prettierd (esto anula la config por defecto de LazyVim)
    opts.formatters_by_ft.markdown = { "prettierd" }
    opts.formatters_by_ft["markdown.mdx"] = { "prettierd" }

    -- Quitar los que no usas
    opts.formatters_by_ft.fish = nil
    opts.formatters_by_ft.ps1 = { "powershell_es" }

    -- Configurar biome
    opts.formatters = opts.formatters or {}
    opts.formatters.biome = {
      command = vim.fn.expand("~/AppData/Local/nvim-data/mason/bin/biome.cmd"),
    }
  end,
}
