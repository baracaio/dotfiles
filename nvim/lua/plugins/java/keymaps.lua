local M = {}

-- Setup general Java keymaps (always available)
function M.setup_general_keymaps()
  -- Java build and run commands
  vim.keymap.set("n", "<leader>jc", "<cmd>!mvn compile<cr>", { desc = "Maven Compile", silent = true })
  vim.keymap.set("n", "<leader>jt", "<cmd>!mvn test<cr>", { desc = "Maven Test", silent = true })
  vim.keymap.set("n", "<leader>jp", "<cmd>!mvn package<cr>", { desc = "Maven Package", silent = true })
  vim.keymap.set("n", "<leader>ji", "<cmd>!mvn install<cr>", { desc = "Maven Install", silent = true })
  vim.keymap.set("n", "<leader>jr", "<cmd>!mvn spring-boot:run<cr>", { desc = "Spring Boot Run", silent = true })

  -- Gradle alternatives
  vim.keymap.set("n", "<leader>jgb", "<cmd>!./gradlew build<cr>", { desc = "Gradle Build", silent = true })
  vim.keymap.set("n", "<leader>jgt", "<cmd>!./gradlew test<cr>", { desc = "Gradle Test", silent = true })
  vim.keymap.set("n", "<leader>jgr", "<cmd>!./gradlew bootRun<cr>", { desc = "Gradle Boot Run", silent = true })
end

-- Setup LSP-specific keymaps (only when JDTLS is attached)
function M.setup_lsp_keymaps(bufnr, opts)
  local wk_ok, wk = pcall(require, "which-key")

  if wk_ok then
    -- Normal mode keymaps
    wk.add({
      {
        mode = "n",
        buffer = bufnr,
        { "<leader>cx", group = "extract" },
        { "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
        { "<leader>cxc", require("jdtls").extract_constant, desc = "Extract Constant" },
        { "<leader>cgs", require("jdtls").super_implementation, desc = "Goto Super" },
        { "<leader>cgS", require("jdtls.tests").goto_subjects, desc = "Goto Subjects" },
        { "<leader>co", require("jdtls").organize_imports, desc = "Organize Imports" },
      },
    })

    -- Visual mode keymaps
    wk.add({
      {
        mode = "v",
        buffer = bufnr,
        { "<leader>cx", group = "extract" },
        {
          "<leader>cxm",
          [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
          desc = "Extract Method",
        },
        {
          "<leader>cxv",
          [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
          desc = "Extract Variable",
        },
        {
          "<leader>cxc",
          [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
          desc = "Extract Constant",
        },
      },
    })
  else
    -- Fallback if which-key is not available
    vim.keymap.set(
      "n",
      "<leader>cxv",
      require("jdtls").extract_variable_all,
      { buffer = bufnr, desc = "Extract Variable" }
    )
    vim.keymap.set("n", "<leader>cxc", require("jdtls").extract_constant, { buffer = bufnr, desc = "Extract Constant" })
    vim.keymap.set("n", "<leader>cgs", require("jdtls").super_implementation, { buffer = bufnr, desc = "Goto Super" })
    vim.keymap.set("n", "<leader>co", require("jdtls").organize_imports, { buffer = bufnr, desc = "Organize Imports" })

    -- Visual mode
    vim.keymap.set(
      "v",
      "<leader>cxm",
      [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
      { buffer = bufnr, desc = "Extract Method" }
    )
    vim.keymap.set(
      "v",
      "<leader>cxv",
      [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
      { buffer = bufnr, desc = "Extract Variable" }
    )
    vim.keymap.set(
      "v",
      "<leader>cxc",
      [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
      { buffer = bufnr, desc = "Extract Constant" }
    )
  end

  -- Setup DAP integration
  local mason_ok, mason_registry = pcall(require, "mason-registry")
  if mason_ok and opts.dap and mason_registry.is_installed("java-debug-adapter") then
    require("plugins.java.dap").setup_jdtls_dap(opts)

    -- Setup testing keymaps if java-test is available
    if opts.test and mason_registry.is_installed("java-test") then
      M.setup_test_keymaps(bufnr, opts)
    end
  end
end

-- Setup Java testing keymaps
function M.setup_test_keymaps(bufnr, opts)
  local wk_ok, wk = pcall(require, "which-key")

  if wk_ok then
    wk.add({
      {
        mode = "n",
        buffer = bufnr,
        { "<leader>t", group = "test" },
        {
          "<leader>tt",
          function()
            require("jdtls.dap").test_class({
              config_overrides = type(opts.test) ~= "boolean" and opts.test.config_overrides or nil,
            })
          end,
          desc = "Run All Test",
        },
        {
          "<leader>tr",
          function()
            require("jdtls.dap").test_nearest_method({
              config_overrides = type(opts.test) ~= "boolean" and opts.test.config_overrides or nil,
            })
          end,
          desc = "Run Nearest Test",
        },
        { "<leader>tT", require("jdtls.dap").pick_test, desc = "Run Test" },
      },
    })
  else
    -- Fallback keymaps
    vim.keymap.set("n", "<leader>tt", function()
      require("jdtls.dap").test_class({
        config_overrides = type(opts.test) ~= "boolean" and opts.test.config_overrides or nil,
      })
    end, { buffer = bufnr, desc = "Run All Test" })

    vim.keymap.set("n", "<leader>tr", function()
      require("jdtls.dap").test_nearest_method({
        config_overrides = type(opts.test) ~= "boolean" and opts.test.config_overrides or nil,
      })
    end, { buffer = bufnr, desc = "Run Nearest Test" })

    vim.keymap.set("n", "<leader>tT", require("jdtls.dap").pick_test, { buffer = bufnr, desc = "Run Test" })
  end
end

-- Initialize general keymaps
M.setup_general_keymaps()

return M
