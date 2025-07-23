return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
      -- golang
      "gopls",
      "goimports",
      "gofumpt",
      "gomodifytags",
      "gotests",
      "impl",
      "delve",

      -- java
      "jdtls",
      "java-debug-adapter",
      "java-test",
    })
  end,
}
