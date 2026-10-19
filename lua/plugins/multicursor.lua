return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    vim.g.VM_leader = "\\"
    vim.g.VM_theme = "ocean"

    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>", -- Ctrl + n (Sigue igual)
      ["Find Subword Under"] = "<C-n>",

      -- SOLUCIÓN FINAL: Shift + Flechas para evitar conflicto con Ctrl y Alt
      ["Add Cursor Down"] = "<S-Down>", -- Mayús + Flecha Abajo
      ["Add Cursor Up"] = "<S-Up>", -- Mayús + Flecha Arriba

      ["Select All"] = "<C-a>", -- Ctrl + a para seleccionar todo
    }
  end,
}
