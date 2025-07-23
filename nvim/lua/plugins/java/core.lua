local java_filetypes = { "java" }

-- Utility function to extend or override a config table
local function extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom)
  end
  return config
end

return {
  "mfussenegger/nvim-jdtls",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "folke/which-key.nvim",
  },
  ft = java_filetypes,

  opts = function()
    -- Build jdtls command
    local cmd = { vim.fn.exepath("jdtls") }

    -- Add lombok support if mason is available
    local mason_ok, mason_registry = pcall(require, "mason-registry")
    if mason_ok and mason_registry.is_installed("jdtls") then
      local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
      table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
    end

    return {
      -- Root directory detection
      root_dir = function(fname)
        local lspconfig = require("lspconfig")
        return lspconfig.util.root_pattern(
          "build.gradle",
          "build.gradle.kts",
          "pom.xml",
          "settings.gradle",
          "settings.gradle.kts",
          "build.xml",
          ".git"
        )(fname)
      end,

      -- Project name from root directory
      project_name = function(root_dir)
        return root_dir and vim.fs.basename(root_dir)
      end,

      -- JDTLS workspace directories
      jdtls_config_dir = function(project_name)
        return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
      end,

      jdtls_workspace_dir = function(project_name)
        return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
      end,

      -- Command to run JDTLS
      cmd = cmd,

      full_cmd = function(opts)
        local fname = vim.api.nvim_buf_get_name(0)
        local root_dir = opts.root_dir(fname)
        local project_name = opts.project_name(root_dir)
        local cmd = vim.deepcopy(opts.cmd)

        if project_name then
          vim.list_extend(cmd, {
            "-configuration",
            opts.jdtls_config_dir(project_name),
            "-data",
            opts.jdtls_workspace_dir(project_name),
          })
        end
        return cmd
      end,

      -- DAP configuration
      dap = {
        hotcodereplace = "auto",
        config_overrides = {},
      },
      dap_main = {}, -- Main class configs
      test = true, -- Enable testing support

      -- LSP settings
      settings = {
        java = {
          inlayHints = {
            parameterNames = {
              enabled = "all",
            },
          },
          -- Additional settings can go here
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            updateBuildConfiguration = "interactive",
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          format = {
            enabled = true,
          },
        },
        signatureHelp = {
          enabled = true,
        },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
          },
        },
        contentProvider = {
          preferred = "fernflower",
        },
        extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
      },
    }
  end,

  config = function(_, opts)
    -- Import other modules
    require("plugins.java.dap")
    require("plugins.java.keymaps")

    -- Find bundles for debugging/testing
    local bundles = {}
    local mason_ok, mason_registry = pcall(require, "mason-registry")

    if mason_ok then
      if opts.dap and mason_registry.is_installed("java-debug-adapter") then
        local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
        local java_dbg_path = java_dbg_pkg:get_install_path()
        local jar_patterns = {
          java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
        }

        -- Add java-test bundles if testing is enabled
        if opts.test and mason_registry.is_installed("java-test") then
          local java_test_pkg = mason_registry.get_package("java-test")
          local java_test_path = java_test_pkg:get_install_path()
          vim.list_extend(jar_patterns, {
            java_test_path .. "/extension/server/*.jar",
          })
        end

        for _, jar_pattern in ipairs(jar_patterns) do
          for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
            table.insert(bundles, bundle)
          end
        end
      end
    end

    local function attach_jdtls()
      local fname = vim.api.nvim_buf_get_name(0)

      -- Build configuration
      local config = extend_or_override({
        cmd = opts.full_cmd(opts),
        root_dir = opts.root_dir(fname),
        init_options = {
          bundles = bundles,
        },
        settings = opts.settings,
        -- Enable completion capabilities
        capabilities = require("cmp_nvim_lsp") and require("cmp_nvim_lsp").default_capabilities() or nil,
      }, opts.jdtls)

      -- Start or attach to JDTLS
      require("jdtls").start_or_attach(config)
    end

    -- Auto-attach for Java files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = java_filetypes,
      callback = attach_jdtls,
    })

    -- Setup keymaps and DAP after LSP attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then
          -- Setup Java-specific keymaps
          require("plugins.java.keymaps").setup_lsp_keymaps(args.buf, opts)
        end
      end,
    })

    -- Initial attach for the first file
    attach_jdtls()
  end,
}
