local M = {}

-- Setup Java debugging configuration
local function setup_java_dap()
  local dap = require("dap")

  -- Simple configuration to attach to remote java debug process
  -- Useful for debugging Spring Boot apps with `mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"`
  dap.configurations.java = {
    {
      type = "java",
      request = "attach",
      name = "Debug (Attach) - Remote",
      hostName = "127.0.0.1",
      port = 5005,
    },
    {
      type = "java",
      request = "launch",
      name = "Debug (Launch) - Current File",
      mainClass = "${file}",
    },
  }
end

-- Setup function to be called after JDTLS attaches
function M.setup_jdtls_dap(opts)
  local mason_ok, mason_registry = pcall(require, "mason-registry")

  if mason_ok and opts.dap and mason_registry.is_installed("java-debug-adapter") then
    -- Setup JDTLS DAP integration
    require("jdtls").setup_dap(opts.dap)

    if opts.dap_main then
      require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
    end
  end
end

-- Initialize Java DAP
setup_java_dap()

return M
