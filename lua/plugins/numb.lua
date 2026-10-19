return {
  "nacro90/numb.nvim",
  event = "CmdLineEnter",
  opts = {
    show_numbers = true, -- Corregido: añadido la 's' final
    show_cursorline = true,
    number_only = false,
    centered_peeking = true,
    disable_for_buftype = { "terminal", "notifier" }, -- Corregido: "notifier"
  },
}
