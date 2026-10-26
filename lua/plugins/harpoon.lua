return {
  "thePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  config = function(_, opts)
    local harpoon = require("harpoon")
    harpoon:setup(opts)
    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "harpoon: Marcar archivo" })
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:togle_quick_mmenu(harpoon:list())
    end, { desc = "harpoon Menú rápido" })
    for i = 1, 9 do
      vim.keymap.set("n", "<A-" .. i .. ">", function()
        harpoon:list():select(i)
      end, { desc = "harpoon: Saltar al archivo " .. i })
    end
  end,
}
