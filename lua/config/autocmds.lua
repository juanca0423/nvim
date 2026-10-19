-- Los autocmds se cargan automáticamente en el evento VeryLazy
-- Autocmds predeterminados que siempre están configurados: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Añade aquí cualquier autocmd adicional
-- usando `vim.api.nvim_create_autocmd`
--
-- O elimina autocmds existentes por su nombre de grupo (que lleva el prefijo `lazyvim_` en los predeterminados)
-- p. ej. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Iniciar Treesitter automáticamente para Handlebars y Pug
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "handlebars", "hbs", "pug" },
  callback = function()
    -- Desactiva las alertas molestas del parser cuando encuentra llaves de plantillas
    vim.bo.syntax = "html"
  end,
})

-- ==========================================================================
-- GRUPOS DE AUTOCOMANDOS (Evita duplicados al recargar)
-- ==========================================================================
local function augroup(name)
  return vim.api.nvim_create_augroup("juan_custom_" .. name, { clear = true })
end
-- 7. ESTÉTICA FINAL
vim.cmd("highlight CursorLineNr guifg=#FAB387 gui=bold")
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#F9E2AF", bg = "#1e1e2e" })

-- Auto-refresh Lualine
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local root = vim.fs.find({ "go.mod", "package.json", ".git", "Makefile" }, {
      upward = true,
      path = vim.fn.expand("%:p:h"),
    })[1]
    if root then
      local root_dir = vim.fs.dirname(root)
      vim.fn.chdir(root_dir)
    end
  end,
})
-- 1. LIMPIEZA DE BASURA SHADA (Específico para Windows)
-- Evita que se acumulen archivos temporales que ralentizan el inicio
if vim.fn.has("win32") == 1 then
  local shada_dir = vim.fn.expand("$LOCALAPPDATA/nvim-data/shada/")
  local tmp_files = vim.fn.glob(shada_dir .. "*.tmp.*", false, true)
  for _, file in ipairs(tmp_files) do
    vim.fn.delete(file)
  end
end

-- 2. DETECCIÓN AUTOMÁTICA DE RAÍZ DEL PROYECTO
-- Cambia el directorio de trabajo (CWD) al encontrar go.mod, .git, etc.
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("project_root"),
  callback = function()
    local root = vim.fs.find({ "go.mod", "package.json", ".git", "Makefile" }, {
      upward = true,
      path = vim.fn.expand("%:p:h"),
    })[1]
    if root then
      local root_dir = vim.fs.dirname(root)
      vim.fn.chdir(root_dir)
    end
  end,
})

-- 3. MEJORAS VISUALES Y DE EDICIÓN
-- Resaltar al copiar texto
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank({ timeout = 200, visual = true })
  end,
})

vim.filetype.add({
  extension = {
    hbs = "handlebars",
    gohtml = "html", -- De paso arreglamos el aviso de Go que viste antes
  },
})

vim.treesitter.language.register("glimmer", "handlebars")

vim.api.nvim_create_user_command("OpenDocs", function()
  -- Usamos la variable de entorno USERPROFILE para que sea una ruta exacta
  local home = os.getenv("USERPROFILE"):gsub("\\", "/")
  local path = home .. "/Documents/Desarrollo/DocMd"

  -- Verificamos si la carpeta existe antes de abrir el picker
  if vim.fn.isdirectory(path) == 0 then
    print("⚠️ Ruta no encontrada: " .. path)
    return
  end

  require("snacks").picker.files({
    cwd = path,
    title = " 󰈙 Mis Documentos MD ",
    -- Esto asegura que use el buscador de Snacks y no Telescope
    finder = "files",
    format = "file",
    hidden = true,
  })
end, {})

-- Set filetype for .env and .env.* files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("env_filetype"),
  pattern = { "*.env", ".env.*" },
  callback = function()
    vim.opt_local.filetype = "sh"
  end,
})

-- ==========================================================================
-- COMANDO PARA LIMPIAR NEVIM (Caché, Shada y Logs)
-- ==========================================================================
vim.api.nvim_create_user_command("ClearNvim", function()
  -- 1. Limpiar Shada (Historial de archivos, marcas, etc.)
  local shada_path = vim.fn.expand(vim.fn.stdpath("data") .. "/shada")
  local files = vim.fn.glob(shada_path .. "/*", false, true)
  for _, file in ipairs(files) do
    vim.fn.delete(file)
  end

  -- 2. Limpiar Logs de LSP (A veces crecen mucho)
  local lsp_log = vim.fn.expand(vim.fn.stdpath("cache") .. "/lsp.log")
  if vim.fn.filereadable(lsp_log) == 1 then
    vim.fn.delete(lsp_log)
  end

  -- 3. Limpiar caché de Telescope (si existe)
  pcall(function()
    require("telescope.builtin").resume() -- Esto a veces limpia estados internos
  end)

  print("✨ Neovim está limpio: Shada y Logs eliminados.")
end, { desc = "Limpia archivos temporales y logs de Neovim" })

-- ==========================================================================
-- COMANDOS DE UTILIDAD PARA DESARROLLO GO
-- ==========================================================================

-- Limpiar caché de Go (Compilación, Tests y Módulos)
vim.api.nvim_create_user_command("GoClean", function()
  print("🧹 Limpiando caché de Go...")
  vim.fn.system("go clean -cache -testcache -modcache")
  print("✨ Caché de Go eliminada correctamente.")
end, { desc = "Limpia toda la caché de Go" })

-- Formatear e Importar (Goimports alternativo)
vim.api.nvim_create_user_command("GoFix", function()
  vim.lsp.buf.format()
  vim.diagnostic.setqflist() -- Envía errores a la lista quickfix
  print("🛠️ Formateo aplicado y diagnósticos actualizados.")
end, { desc = "Formatea el buffer y revisa errores" })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    -- 1. Primero organizamos imports con un timeout seguro
    -- Usamos la estructura completa de CodeActionParams para evitar type errors
    local params = {
      textDocument = vim.lsp.util.make_text_document_params(0),
      range = vim.lsp.util.make_range_params(0, "utf-8").range,
      context = { only = { "source.organizeImports" } },
    }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)

    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
        end
      end
    end

    -- 2. Formatear con Conform
    require("conform").format({ bufnr = 0 })
  end,
})
-- ==========================================================================
-- EJECUTOR RÁPIDO DE GO (Terminal Flotante)
-- ==========================================================================
local function run_go_project()
  -- Guardamos el archivo actual antes de correr (evita correr código viejo)
  vim.cmd("silent! write")

  -- Verificamos si existe un go.mod para asegurarnos que es un proyecto Go
  if vim.fn.filereadable("go.mod") == 1 or vim.bo.filetype == "go" then
    -- Usamos ToggleTerm para lanzar el comando en una terminal flotante
    -- "go run ." corre todo el paquete actual
    vim.cmd('TermExec cmd="go run ." direction=float')
  else
    print("❌ No se detectó un proyecto Go o archivo .go")
  end
end

-- Creamos el mapeo: <leader>rr (Run Root)
vim.keymap.set("n", "<leader>rr", run_go_project, { desc = "Ejecutar Proyecto Go" })

-- Activar Inlay Hints automáticamente (v0.11+)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

-- Otra opción más moderna si la anterior no basta:
-- Esto le dice a Neovim que restaure el estado de la terminal al salir
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.opt.guicursor = "a:ver25" -- Restaura el cursor a una barra al salir
    -- Ejecuta un clear automático al cerrar Neovim (el truco final)
    vim.fn.jobstart("cls", { detach = true })
  end,
})

-- 1. Configurar el símbolo de showbreak
vim.opt.showbreak = "↳ "

-- 2. Asignar el resalte de ventana solo a las ventanas que contengan archivos
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
  pattern = "*",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true

    -- Remapea el elemento NonText local de ESTA ventana hacia nuestro grupo personalizado
    vim.opt_local.winhighlight = "NonText:CatppuccinShowBreak"
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    if vim.g.colors_name ~= "catppuccin" and vim.g.colors_name ~= nil then
      vim.cmd("colorscheme catppuccin")
    end
  end,
})
