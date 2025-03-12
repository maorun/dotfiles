return {
    {
        enabled = false,
        -- A typical debug flow consists of:
        -- Setting breakpoints via :lua require'dap'.toggle_breakpoint().
        -- Launching debug sessions and resuming execution via :lua require'dap'.continue().
        -- Stepping through code via :lua require'dap'.step_over() and :lua require'dap'.step_into().
        -- Inspecting the state via the built-in REPL: :lua require'dap'.repl.open() or using the widget UI (:help dap-widgets)
        -- See :help dap.txt, :help dap-mapping and :help dap-api.
        'mfussenegger/nvim-dap',
        dependencies = {
            { "igorlfs/nvim-dap-view", opts = {} },
            -- https://github.com/nvim-telescope/telescope-dap.nvim
        },
        init = function()
            -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-chrome

            -- pwa
            require("dap").adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = { "~/js-debug/src/dapDebugServer.js", "${port}" },
                }
            }
            require("dap").configurations.javascript = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                },
            }
        end,
    } }
