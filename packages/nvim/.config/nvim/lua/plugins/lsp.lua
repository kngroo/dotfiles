return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- LazyVim's lang.python extra ships basedpyright, whose default
        -- typeCheckingMode ("recommended") floods a partially-typed codebase
        -- with diagnostics. "standard" matches roughly what
        -- Pylance/Cursor surfaces.
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                  variableTypes = true,
                  callArgumentNames = true,
                  functionReturnTypes = true,
                },
              },
            },
          },
        },
      },
    },
  },
}
