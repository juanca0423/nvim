return {
  "vuki656/package-info.nvim",
  dependencies = { "munifTanjim/nui.nvim" },
  event = { "bufRead package.json", "BufNewFile packae.json" },
  opts = {
    autostart = true,
    hide_up_to_date = true,
    virtual_text = {
      prefix = " ",
      pos = "eol",
    },
  },
  config = function(_, opts)
    require("package-info").setup(opts)
    vim.api.nvim_create_autocmd("fileType", {
      pattern = "json",
      callback = function()
        if vim.fn.expand("%:t") == "package.json" then
          local pi = require("package-info")
          local opts_key = { silent = true, buffer = true }
          vim.keymap.set("n", "<leader>ns", pi.show, opts_key, { desc = "Estado de las Versiones" })
          vim.keymap.set("n", "<leader>nd", pi.delete, opts_key, { desc = "Eliminar Dependencia" })
          vim.keymap.set("n", "<leader>nu", pi.change_version, opts_key, { desc = "Actualizar Dependencia" })
        end
      end,
    })
  end,
}
