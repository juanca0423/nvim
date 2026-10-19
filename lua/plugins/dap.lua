-- ~/.config/nvim/lua/plugins/dap.lua
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
    "nvim-neotest/nvim-nio",
  },
  -- TODOS los atajos van aquí para lazy-loading automático y which-key
  key = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F12>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>b",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>B",
      function()
        require("dap").set_breakpoint(vim.fn.input("Condición: "))
      end,
      desc = "Debug: Conditional Breakpoint",
    },
    {
      "<leader>du",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: Toggle UI",
    },
    {
      "<leader>dq",
      function()
        require("dap").terminate()
        require("dapui").close()
      end,
      desc = "Debug: Stop & Close UI",
    },
    {
      "<leader>dh",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "Debug: Hover Variable",
    },
    {
      "<leader>de",
      function()
        require("dapui").eval()
      end,
      desc = "Debug: Evaluar Expresión",
      mode = { "n", "v" },
    },
    {
      "<leader>dr",
      function()
        require("dap").repl.open()
      end,
      desc = "Debug: Abrir REPL",
    },
    {
      "<leader>gt",
      function()
        require("dap-go").debug_test()
      end,
      desc = "Debug: Go Test (Current)",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- 1. Inicializar UI y estética
    dapui.setup()
    vim.fn.sign_define("DapBreakpoint", { text = "󰏃 ", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DiagnosticInfo" })

    -- 2. Automatización de la UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- 3. Configuración JS/TS (Node y Chrome)
    local js_debug_path = vim.fn.stdpath("data")
      .. "/mason/packages/js-debug-adapter/js-debug/out/src/dapDebugServer.js"

    dap.adapters["pwa-node"] = { type = "executable", command = "node", args = { js_debug_path, "${port}" } }
    dap.adapters["pwa-chrome"] = { type = "executable", command = "node", args = { js_debug_path, "${port}" } }

    local js_config = {
      { type = "pwa-node", request = "launch", name = "Launch file", program = "${file}", cwd = "${workspaceFolder}" },
    }
    dap.configurations.javascript = js_config
    dap.configurations.typescript = js_config

    local react_config = {
      {
        type = "pwa-chrome",
        request = "launch",
        name = "Launch Chrome (localhost:5173)",
        url = "http://localhost:5173",
        webRoot = "${workspaceFolder}",
        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
      },
    }
    dap.configurations.typescriptreact = react_config
    dap.configurations.javascriptreact = react_config

    -- 4. Configuración Go (Delve)
    require("dap-go").setup({
      delve = {
        -- LazyVim ya añade mason/bin al PATH. "dlv" funciona en Windows/Linux/Mac.
        -- Si tienes problemas, descomenta la línea de abajo:
        -- path = vim.fn.stdpath("data") .. "\\mason\\bin\\dlv.cmd",
        initialize_timeout_sec = 20,
      },
      dap_configurations = {
        {
          type = "go",
          name = "Debug test (Package)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      },
    })
  end,
}
