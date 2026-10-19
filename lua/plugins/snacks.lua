-- ~/.config/nvim/lua/plugins/snacks.lua
return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        pick = function(cmd, opts)
          ---@diagnostic disable-next-line: undefined-global
          return lazyvim.pick(cmd, opts)()
        end,
        header = [[
██████╗  ██████╗      ██╗███████╗
██╔════╝ ██╔═══██╗     ██║██╔════╝
██║  ███╗██║   ██║     ██║███████╗
██║   ██║██║   ██║██   ██║╚════██║
╚██████╔╝╚██████╔╝╚█████╔╝███████║
╚═════╝  ╚═════╝  ╚════╝ ╚══════╝
  DEVELOPER: JUAN CARLOS
GO • JS • HTML • CSS STACK
]],
        ---@diagnostic disable-next-line: undefined-doc-name
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = "  ", key = "b", desc = "Buscar Archivo", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "  ", key = "n", desc = "Nuevo Archivo", action = ":ene | startinsert" },
          { icon = "  ", key = "t", desc = "Buscar Texto", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "  ", key = "r", desc = "Archivo Reciente", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = "  ",
            key = "c",
            desc = "Configuración",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = "  ", key = "s", desc = "Restaurar Sesión", section = "session" },
          { icon = "  ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲  ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = "  ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
