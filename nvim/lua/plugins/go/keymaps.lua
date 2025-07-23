-- Core Go commands
vim.keymap.set("n", "<leader>gr", "<cmd>GoRun<cr>", { desc = "Go Run" })
vim.keymap.set("n", "<leader>gb", "<cmd>GoBuild<cr>", { desc = "Go Build" })
vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<cr>", { desc = "Go Test" })
vim.keymap.set("n", "<leader>gf", "<cmd>GoTestFunc<cr>", { desc = "Go Test Function" })
vim.keymap.set("n", "<leader>gT", "<cmd>GoTestFile<cr>", { desc = "Go Test File" })
vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<cr>", { desc = "Go Coverage" })

-- Code actions and refactoring
vim.keymap.set("n", "<leader>gfs", "<cmd>GoFillStruct<cr>", { desc = "Go Fill Struct" })
vim.keymap.set("n", "<leader>gie", "<cmd>GoIfErr<cr>", { desc = "Go If Err" })
vim.keymap.set("n", "<leader>gim", "<cmd>GoImpl<cr>", { desc = "Go Implement Interface" })

-- Struct tags
vim.keymap.set("n", "<leader>gat", "<cmd>GoAddTag<cr>", { desc = "Go Add Tag" })
vim.keymap.set("n", "<leader>grt", "<cmd>GoRmTag<cr>", { desc = "Go Remove Tag" })

-- Navigation and documentation
vim.keymap.set("n", "<leader>ga", "<cmd>GoAlt<cr>", { desc = "Go Alternate File" })
vim.keymap.set("n", "<leader>god", "<cmd>GoDoc<cr>", { desc = "Go Documentation" })
vim.keymap.set("n", "<leader>goo", "<cmd>GoPkgOutline<cr>", { desc = "Go Package Outline" })

-- Module management
vim.keymap.set("n", "<leader>gmt", "<cmd>GoModTidy<cr>", { desc = "Go Mod Tidy" })
vim.keymap.set("n", "<leader>gmi", "<cmd>GoModInit<cr>", { desc = "Go Mod Init" })

-- Go-specific debug commands
vim.keymap.set("n", "<leader>gdd", "<cmd>GoDebug<cr>", { desc = "Go Debug" })
vim.keymap.set("n", "<leader>gdt", "<cmd>GoDebug -t<cr>", { desc = "Go Debug Test" })
vim.keymap.set("n", "<leader>gdn", "<cmd>GoDebug -n<cr>", { desc = "Go Debug Nearest Test" })
vim.keymap.set("n", "<leader>gds", "<cmd>GoDbgStop<cr>", { desc = "Go Debug Stop" })

-- Test generation
vim.keymap.set("n", "<leader>gta", "<cmd>GoAddTest<cr>", { desc = "Go Add Test" })
vim.keymap.set("n", "<leader>gte", "<cmd>GoAddExpTest<cr>", { desc = "Go Add Exported Test" })
vim.keymap.set("n", "<leader>gtA", "<cmd>GoAddAllTest<cr>", { desc = "Go Add All Tests" })

-- Code generation and utilities
vim.keymap.set("n", "<leader>gcm", "<cmd>GoCmt<cr>", { desc = "Go Generate Comment" })
vim.keymap.set("n", "<leader>gic", "<cmd>GoInstallBinaries<cr>", { desc = "Go Install Binaries" })
