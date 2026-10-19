return {
  -- 1. Soporte de Treesitter para sintaxis HTTP y JSON
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "http", "json" })
      end
    end,
  },

  -- 2. Plugin principal: hurl.nvim
  {
    "jellydn/hurl.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "hurl",
    cmd = {
      "HurlRunner",
      "HurlRunnerAt",
      "HurlRunnerToEntry",
      "HurlRunnerToEnd",
      "HurlToggleMode",
    },
    opts = {
      debug = false,
      show_notification = true,
      mode = "popup", -- O "split" según prefieras
      -- Puedes definir aquí un archivo de variables por defecto si lo deseas
      -- variables-file = vim.fn.getcwd() .. "/api/env/dev.env",
      formatters = {
        json = { "jq" },
        html = { "prettier", "--parser", "html" },
        xml = { "tidy", "-xml", "-i", "-q" },
      },
      mappings = {
        close = "q",
        next_panel = "<C-n>",
        prev_panel = "<C-p>",
      },
    },
    keys = {
      { "<leader>a", "<cmd>HurlRunner<CR>", desc = "Ejecutar archivo Hurl completo", mode = "n" },
      { "<leader>h", ":HurlRunner<CR>", desc = "Ejecutar selección Hurl", mode = "v" },
      -- Comandos nativos de hurl.nvim corregidos
      { "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Alternar modo Hurl (split/popup)", mode = "n" },
      -- Agrega estas funciones a la sección `keys` de tu configuración de hurl.nvim:

      -- 1. Guardar informe completo de todas las entradas en un archivo Markdown (.md)
      {
        "<leader>tf",
        function()
          local file = vim.fn.expand("%:p")
          local file_name = vim.fn.expand("%:t:r")
          local logs_dir = vim.fn.getcwd() .. "/api/logs"

          if vim.fn.isdirectory(logs_dir) == 0 then
            vim.fn.mkdir(logs_dir, "p")
          end

          local timestamp = os.date("%Y%m%d_%H%M%S")
          local output_md = string.format("%s/%s_%s.md", logs_dir, file_name, timestamp)

          -- Ejecutamos Hurl en modo verbose y canalizamos toda la salida estructurada a un Markdown
          local cmd =
            string.format("!hurl --verbose %s > %s 2>&1", vim.fn.fnameescape(file), vim.fn.fnameescape(output_md))

          vim.cmd(cmd)
          vim.notify("Reporte Markdown guardado en: " .. output_md, vim.log.levels.INFO)

          -- Opcional: abrir el reporte Markdown generado inmediatamente en un split
          vim.cmd("vsplit " .. vim.fn.fnameescape(output_md))
        end,
        desc = "Guardar reporte completo de todas las peticiones en Markdown (.md)",
        mode = "n",
      },

      -- 2. Generar un Reporte HTML interactivo con gráfica de rendimiento de Hurl
      {
        "<leader>th",
        function()
          local file = vim.fn.expand("%:p")
          local report_dir = vim.fn.getcwd() .. "/api/logs/report_html"

          local cmd =
            string.format("!hurl --report-html %s %s", vim.fn.fnameescape(report_dir), vim.fn.fnameescape(file))

          vim.cmd(cmd)
          vim.notify("Reporte HTML generado en: " .. report_dir .. "/index.html", vim.log.levels.INFO)
        end,
        desc = "Generar reporte HTML interactivo de todas las peticiones",
        mode = "n",
      },
      {
        "<leader>tg",
        function()
          local file = vim.fn.expand("%:p")
          local logs_dir = vim.fn.getcwd() .. "/api/logs"

          -- Crear la carpeta api/logs si no existe
          if vim.fn.isdirectory(logs_dir) == 0 then
            vim.fn.mkdir(logs_dir, "p")
          end

          local output_file = logs_dir .. "/last_response.json"
          local cmd = string.format("!hurl --output %s %s", vim.fn.fnameescape(output_file), vim.fn.fnameescape(file))

          vim.cmd(cmd)
          vim.notify("Respuesta guardada en: " .. output_file, vim.log.levels.INFO)
        end,
        desc = "Ejecutar y guardar respuesta en api/logs/last_response.json",
        mode = "n",
      },
      {
        "<leader>h",
        function()
          -- 1. Definir la ruta de la carpeta donde guardas tus entornos
          local env_dir = vim.fn.getcwd() .. "/api/env"

          -- 2. Buscar archivos que terminen en .env dentro de la carpeta
          local env_files = vim.fn.glob(env_dir .. "/*.env", false, true)

          if #env_files == 0 then
            vim.notify("No se encontraron archivos .env en " .. env_dir, vim.log.levels.WARN)
            vim.cmd("HurlRunner")
            return
          end

          -- 3. Extraer solo los nombres de los archivos para mostrarlos limpiamente en el menú
          local choices = {}
          for _, file in ipairs(env_files) do
            table.insert(choices, vim.fs.basename(file))
          end

          -- 4. Mostrar el menú interactivo con vim.ui.select
          vim.ui.select(choices, {
            prompt = "Selecciona el entorno de Hurl:",
            format_item = function(item)
              return "⚙️ Entorno: " .. item
            end,
          }, function(choice)
            -- Si el usuario presiona ESC o cancela, choice será nil
            if not choice then
              return
            end

            -- 5. Construir la ruta completa del archivo seleccionado y ejecutar Hurl
            local selected_env_file = env_dir .. "/" .. choice
            vim.notify("Ejecutando con entorno: " .. choice, vim.log.levels.INFO)

            local cmd = string.format("HurlRunner --variables-file %s", vim.fn.fnameescape(selected_env_file))
            vim.cmd(cmd)
          end)
        end,
        desc = "Seleccionar entorno interactivamente y ejecutar Hurl",
        mode = "n",
      },
    },
  },

  -- 3. Render Markdown configurado de forma independiente (fuera de hurl)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown" },
    },
    ft = { "markdown" },
  },
}
