-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.fn.has("win32") == 1 then
  vim.opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  -- ESTA LÍNEA ES EL ESCUDO:
  vim.opt.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow"
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; if($?) { exit $LASTEXITCODE }"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
  -- Permitir que Neovim abra enlaces con 'gx' en Windows
  vim.g.netrw_browsex_viewer = "cmd /c start"

  -- Limpieza de pantalla al salir usando la configuración de shell de Neovim
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      -- Usamos la función interna de Neovim que ya sabe que usas pwsh
      vim.fn.system("cls")
    end,
  })
end
