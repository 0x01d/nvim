vim.lsp.start({
  name = "gopls",
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/gopls" },
  root_dir = vim.fs.root(0, { "go.mod", "go.work", ".git" }),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
