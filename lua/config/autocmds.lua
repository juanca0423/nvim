-- Los autocmds se cargan automáticamente en el evento VeryLazy
-- Autocmds predeterminados que siempre están configurados: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Añade aquí cualquier autocmd adicional
-- usando `vim.api.nvim_create_autocmd`
--
-- O elimina autocmds existentes por su nombre de grupo (que lleva el prefijo `lazyvim_` en los predeterminados)
-- p. ej. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup("juan_custom_" .. name, { clear = true })
end

-- Estética inicial y resaltados
vim.cmd("highlight CursorLineNr guifg=#FAB387 gui=bold")
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#F9E2AF", bg = "#1e1e2e" })

-- 1. Limpieza de Shada en Windows al iniciar
if vim.fn.has("win32") == 1 then
  local shada_dir = vim.fn.expand("$LOCALAPPDATA/nvim-data/shada/")
  local tmp_files = vim.fn.glob(shada_dir .. "*.tmp.*", false, true)
  for _, file in ipairs(tmp_files) do
    vim.fn.delete(file)
  end
end

-- 2. Detección automática de raíz del proyecto (Unificado)
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

-- 3. Resaltar texto al copiar (Yank)
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank({ timeout = 200, visual = true })
  end,
})

-- 4. Set filetype para archivos .env
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("env_filetype"),
  pattern = { "*.env", ".env.*" },
  callback = function()
    vim.opt_local.filetype = "sh"
  end,
})

-- 5. Configurar saltos de línea visuales
vim.opt.showbreak = "↳ "
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
  group = augroup("wrap_settings"),
  pattern = "*",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.winhighlight = "NonText:CatppuccinShowBreak"
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup("colorscheme_check"),
  callback = function()
    if vim.g.colors_name ~= "catppuccin" and vim.g.colors_name ~= nil then
      vim.cmd("colorscheme catppuccin")
    end
  end,
})

-- 6. Activar Inlay Hints automáticamente
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("inlay_hints"),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

-- 7. Restaurar cursor al salir de Neovim
vim.api.nvim_create_autocmd("VimLeave", {
  group = augroup("vim_leave"),
  callback = function()
    vim.opt.guicursor = "a:ver25"
    vim.fn.jobstart("cls", { detach = true })
  end,
})

-- ==========================================================================
-- AUTOCMD ESPECÍFICO PARA GO: Organizar imports y formatear al guardar
-- ==========================================================================
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("go_format_save"),
  pattern = "*.go",
  callback = function()
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

    require("conform").format({ bufnr = 0 })
  end,
})

-- ==========================================================================
-- AUTOCMD ESPECÍFICO PARA GO: Organizar imports y formatear al guardar
-- ==========================================================================
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = augroup("go_format_save"),
--   pattern = "*.go",
--   callback = function()
--     local params = {
--       textDocument = vim.lsp.util.make_text_document_params(0),
--       range = vim.lsp.util.make_range_params(0, "utf-8").range,
--       context = { only = { "source.organizeImports" } },
--     }
--     local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
--
--     for _, res in pairs(result or {}) do
--       for _, r in pairs(res.result or {}) do
--         if r.edit then
--           vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
--         end
--       end
--     end
--
--     require("conform").format({ bufnr = 0 })
--   end,
-- })

-- ==========================================================================
-- COMANDOS DE USUARIO PERSONALIZADOS
-- ==========================================================================
vim.api.nvim_create_user_command("OpenDocs", function()
  local home = os.getenv("USERPROFILE"):gsub("\\", "/")
  local path = home .. "/Documents/Desarrollo/DocMd"

  if vim.fn.isdirectory(path) == 0 then
    print("⚠️ Ruta no encontrada: " .. path)
    return
  end

  require("snacks").picker.files({
    cwd = path,
    title = " 󰈙 Mis Documentos MD ",
    finder = "files",
    format = "file",
    hidden = true,
  })
end, {})

vim.api.nvim_create_user_command("ClearNvim", function()
  local shada_path = vim.fn.expand(vim.fn.stdpath("data") .. "/shada")
  local files = vim.fn.glob(shada_path .. "/*", false, true)
  for _, file in ipairs(files) do
    vim.fn.delete(file)
  end

  local lsp_log = vim.fn.expand(vim.fn.stdpath("cache") .. "/lsp.log")
  if vim.fn.filereadable(lsp_log) == 1 then
    vim.fn.delete(lsp_log)
  end

  pcall(function()
    require("telescope.builtin").resume()
  end)

  print("✨ Neovim está limpio: Shada y Logs eliminados.")
end, { desc = "Limpia archivos temporales y logs de Neovim" })

vim.api.nvim_create_user_command("GoClean", function()
  print("🧹 Limpiando caché de Go...")
  vim.fn.system("go clean -cache -testcache -modcache")
  print("✨ Caché de Go eliminada correctamente.")
end, { desc = "Limpia toda la caché de Go" })

vim.api.nvim_create_user_command("GoFix", function()
  vim.lsp.buf.format()
  vim.diagnostic.setqflist()
  print("🛠️ Formateo aplicado y diagnósticos actualizados.")
end, { desc = "Formatea el buffer y revisa errores" })

-- ==========================================================================
-- MAPEOS DE TECLA ÚTILES
-- ==========================================================================
local function run_go_project()
  vim.cmd("silent! write")
  if vim.fn.filereadable("go.mod") == 1 or vim.bo.filetype == "go" then
    vim.cmd('TermExec cmd="go run ." direction=float')
  else
    print("❌ No se detectó un proyecto Go o archivo .go")
  end
end

vim.keymap.set("n", "<leader>rr", run_go_project, { desc = "Ejecutar Proyecto Go" })
