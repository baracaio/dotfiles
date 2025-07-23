return {
  lsp_cfg = {
    settings = {
      gopls = {
        -- Disable annoying style check analyses
        analyses = {
          -- Disable package comment warnings
          ST1000 = false, -- "at least one file in a package should have a package comment"
          ST1003 = false, -- "should not use underscores in package names"
          ST1016 = false, -- "should use consistent method receiver names"
          ST1020 = false, -- "comment on exported method should be of the form"
          ST1021 = false, -- "comment on exported type should be of the form"
          ST1022 = false, -- "comment on exported const should be of the form"

          -- Keep useful analyses enabled
          unreachable = true,
          nilness = true,
          unusedparams = true,
          useany = true,
          unusedwrite = true,
          undeclaredname = true,
          fillreturns = true,
          nonewvars = true,
          fieldalignment = false, -- This can be annoying too
          shadow = true,
        },

        -- Other gopls settings
        staticcheck = true,
        gofumpt = true,
        completeUnimported = true,
        usePlaceholders = true,
        matcher = "Fuzzy",
        diagnosticsDelay = "500ms",
        symbolMatcher = "fuzzy",

        -- Codelens settings
        codelenses = {
          generate = true,
          gc_details = true,
          test = true,
          tidy = true,
          vendor = true,
          regenerate_cgo = true,
          upgrade_dependency = true,
        },

        -- Inlay hints
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },

  lsp_gofumpt = true,
  lsp_on_attach = true,
  lsp_keymaps = true,
  lsp_codelens = true,
}
