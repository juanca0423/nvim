-- lua/plugins/luasnip.lua

return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require("luasnip")

    -- Extender filetypes para snippets
    ls.filetype_extend("javascriptreact", { "html" })
    ls.filetype_extend("typescriptreact", { "html" })

    -- Cargar tus snippets personalizados desde lua/config/missnippets.lua
    require("config.missnippets")

    -- Mapeos para saltar entre campos de los snippets
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { desc = "LuaSnip: Saltar al sig. campo" })

    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { desc = "LuaSnip: Saltar al campo anterior" })
  end,
}
