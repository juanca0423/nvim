-- Los mapas de teclas se cargan automáticamente en el evento VeryLazy
-- Mapas de teclas predeterminados que siempre se configuran: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Añade aquí cualquier mapa de teclas adicional
--
-- Este archivo es cargado automáticamente por lazyvim.config.init

-- ¡¡NO UTILICES `LazyVim.safe_keymap_set` EN TU PROPIA CONFIGURACIÓN!!
-- utiliza `vim.keymap.set` en su lugarlocal map = vim.keymap.set

local mimap = vim.keymap.set

-- Mejor movimiento arriba/abajo
mimap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Abajo", expr = true, silent = true })
mimap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Abajo", expr = true, silent = true })
mimap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Arriba", expr = true, silent = true })
mimap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Arriba", expr = true, silent = true })

-- Moverse entre ventanas usando <Ctrl> + hjkl
mimap("n", "<C-h>", "<C-w>h", { desc = "Ir a la ventana izquierda", remap = true })
mimap("n", "<C-j>", "<C-w>j", { desc = "Ir a la ventana inferior", remap = true })
mimap("n", "<C-k>", "<C-w>k", { desc = "Ir a la ventana superior", remap = true })
mimap("n", "<C-l>", "<C-w>l", { desc = "Ir a la ventana derecha", remap = true })

-- Redimensionar ventana usando <Ctrl> + flechas
mimap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Aumentar altura de ventana" })
mimap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Disminuir altura de ventana" })
mimap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Disminuir anchura de ventana" })
mimap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Aumentar anchura de ventana" })

-- Snippets (Salto con J y K)
vim.keymap.set({ "i", "s" }, ".k", function()
  local ls = require("luasnip")
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { desc = "Saltar al sig. campo" })

vim.keymap.set({ "i", "s" }, ".j", function()
  local ls = require("luasnip")
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { desc = "Saltar al campo Anterior" })

-- Mover líneas
mimap("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Mover línea abajo" })
mimap("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Mover línea arriba" })

mimap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Mover línea abajo" })
mimap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Mover línea arriba" })
mimap("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Mover líneas abajo" })
mimap("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Mover líneas arriba" })

-- Buffers
mimap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer anterior" })
mimap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Buffer siguiente" })
mimap("n", "[b", "<cmd>bprevious<cr>", { desc = "Buffer anterior" })
mimap("n", "]b", "<cmd>bnext<cr>", { desc = "Buffer siguiente" })
mimap("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Alternar al último buffer" })
mimap("n", "<leader>`", "<cmd>e #<cr>", { desc = "Alternar al último buffer" })
mimap("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Eliminar buffer" })
mimap("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Eliminar otros buffers" })
mimap("n", "<leader>bi", function()
  Snacks.bufdelete.invisible()
end, { desc = "Eliminar buffers invisibles" })
mimap("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Eliminar buffer y ventana" })

-- Limpiar búsqueda y detener snippet al presionar Escape
mimap({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  LazyVim.cmp.actions.snippet_stop()
  return "<esc>"
end, { expr = true, desc = "Escape y limpiar resaltado de búsqueda" })

-- Limpiar búsqueda, actualizar diff y redibujar
mimap(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redibujar / Limpiar búsqueda / Actualizar diff" }
)

-- Comportamiento mejorado de n y N
mimap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Siguiente resultado de búsqueda" })
mimap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Siguiente resultado de búsqueda" })
mimap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Siguiente resultado de búsqueda" })
mimap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Resultado de búsqueda anterior" })
mimap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Resultado de búsqueda anterior" })
mimap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Resultado de búsqueda anterior" })

-- Agregar puntos de interrupción para deshacer (undo breakpoints)
mimap("i", ",", ",<c-g>u")
mimap("i", ".", ".<c-g>u")
mimap("i", ";", ";<c-g>u")

-- Guardar archivo
mimap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Guardar archivo" })

-- Keywordprg
mimap("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Documentación de palabra clave" })

-- Mejor sangría/indentación
mimap("x", "<", "<gv")
mimap("x", ">", ">gv")

-- Comentarios
mimap("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Agregar comentario abajo" })
mimap("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Agregar comentario arriba" })

-- Lazy
mimap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Menú Lazy" })

-- Nuevo archivo
mimap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "Nuevo archivo" })

-- Location list
mimap("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Lista de localizaciones" })

-- Quickfix list
mimap("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Lista Quickfix" })

mimap("n", "[q", vim.cmd.cprev, { desc = "Anterior Quickfix" })
mimap("n", "]q", vim.cmd.cnext, { desc = "Siguiente Quickfix" })

-- Formato
mimap({ "n", "x" }, "<leader>cf", function()
  LazyVim.format({ force = true })
end, { desc = "Dar formato" })

-- Diagnósticos
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
mimap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnóstico de línea" })
mimap("n", "]d", diagnostic_goto(true), { desc = "Siguiente diagnóstico" })
mimap("n", "[d", diagnostic_goto(false), { desc = "Anterior diagnóstico" })
mimap("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Siguiente error" })
mimap("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Anterior error" })
mimap("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Siguiente advertencia" })
mimap("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Anterior advertencia" })

-- stylua: ignore start

-- Alternar opciones (Toggles con Snacks)
LazyVim.format.snacks_toggle():map("<leader>uf")
LazyVim.format.snacks_toggle(true):map("<leader>uF")
Snacks.toggle.option("spell", { name = "Ortografía" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Ajuste de línea (Wrap)" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Números relativos" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("conceallevel",
  { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Nivel de ocultamiento (Conceal)" }):map(
  "<leader>uc")
Snacks.toggle.option("showtabline",
  { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Barra de pestañas" }):map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Fondo oscuro" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end

-- Lazygit
if vim.fn.executable("lazygit") == 1 then
  mimap("n", "<leader>gg", function() Snacks.lazygit({ cwd = LazyVim.root.git() }) end,
    { desc = "Lazygit (Directorio raíz)" })
  mimap("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (Directorio actual)" })
end

mimap("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Historial Git (Directorio actual)" })
mimap("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame por línea" })
mimap("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Historial del archivo actual" })
mimap("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = LazyVim.root.git() }) end, { desc = "Historial Git" })
mimap({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Abrir en Git (Navegador)" })
mimap({ "n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
end, { desc = "Copiar enlace de Git" })

-- Salir
mimap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Salir de todo" })

-- Inspeccionar resaltado bajo el cursor
mimap("n", "<leader>ui", vim.show_pos, { desc = "Inspeccionar posición" })
mimap("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, { desc = "Inspeccionar árbol Treesitter" })

-- LazyVim Registro de cambios
mimap("n", "<leader>L", function() LazyVim.news.changelog() end, { desc = "Registro de cambios de LazyVim" })

-- Terminal flotante
mimap("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (Directorio actual)" })
mimap("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = LazyVim.root() }) end,
  { desc = "Terminal (Directorio raíz)" })
mimap({ "n", "t" }, "<c-/>", function() Snacks.terminal.focus(nil, { cwd = LazyVim.root() }) end,
  { desc = "Terminal (Directorio raíz)" })
mimap({ "n", "t" }, "<c-_>", function() Snacks.terminal.focus(nil, { cwd = LazyVim.root() }) end,
  { desc = "which_key_ignore" })

-- Ventanas / Splitting
mimap("n", "<leader>-", "<C-W>s", { desc = "Dividir ventana abajo", remap = true })
mimap("n", "<leader>|", "<C-W>v", { desc = "Dividir ventana a la derecha", remap = true })
mimap("n", "<leader>wd", "<C-W>c", { desc = "Cerrar ventana", remap = true })
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

-- Pestañas
mimap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Última pestaña" })
mimap("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Cerrar las demás pestañas" })
mimap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "Primera pestaña" })
mimap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Nueva pestaña" })
mimap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Siguiente pestaña" })
mimap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Cerrar pestaña" })
mimap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Pestaña anterior" })

-- Lua
mimap({ "n", "x" }, "<localleader>r", function() Snacks.debug.run() end, { desc = "Ejecutar Lua" })
