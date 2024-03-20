if vim.g.vscode then
  return {
    "fatih/vim-go",
    enabled = false,
  }
else
  return {
    "fatih/vim-go",
    enabled = false,
    config = function()
      vim.g.go_gopls_enabled = 0
      vim.g.go_gopls_options = {
        "/Users/wanglele/go/1.20.0/bin/gopls",
        "-remote=auto",
      }
      vim.g.go_fmt_autosave = 0
      vim.g.go_imports_autosave = 0
      vim.g.go_code_completion_enabled = 0
    end,
  }
end
