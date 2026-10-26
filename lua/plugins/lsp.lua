-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason.nvim",
    "mason-lspconfig.nvim",
    "folke/lazydev.nvim",
    { "bilal2453/luvit-meta", lazy = true },
  },
  config = function()
    vim.filetype.add({
      extension = {
        hbs = "handlebars",
        handlebars = "handlebars",
        gowork = "gowork",
        gotmpl = "gotmpl",
      },
    })

    require("mason").setup()

    local servers = {
      "pyright",
      -- "lua_ls",
      "gopls",
      "vtsls",
      -- "black",
      "fish_lsp",
      "ts_ls",
      "html",
      "cssls",
      "emmet_language_server",
      "sqls",
    }

    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    local lspconfig = require("lspconfig")
    -- ✅ CORRECCIÓN: blink.cmp no tiene default_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local has_blink, blink = pcall(require, "blink.cmp")
    if has_blink then
      capabilities = blink.get_lsp_capabilities(capabilities)
    end

    for _, server in ipairs(servers) do
      local opts = { capabilities = capabilities }

      if server == "ts_ls" then
        opts.filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
        opts.settings = {
          typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
          javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
        }
      elseif server == "html" then
        opts.filetypes = { "html", "templ", "pug", "handlebars", "hbs" }
      elseif server == "emmet_language_server" then
        opts.filetypes = { "html", "css", "scss", "pug", "handlebars", "hbs", "javascriptreact", "typescriptreact" }
      elseif server == "lua_ls" then
        opts.settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        }
      elseif server == "gopls" then
        opts.filetypes = { "go", "gomod", "gowork", "gotmpl" }
      end

      lspconfig[server].setup(opts)
    end
  end,
}
