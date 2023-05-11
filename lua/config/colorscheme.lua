local onedark = require("onedark")

-- place this before colorscheme is set
vim.api.nvim_create_autocmd( 'ColorScheme', {
  command = [[highlight DiagnosticUnderlineError gui=undercurl]],
  desc = "undercurl errors"
})

onedark.setup {
  style = "dark",
  code_style = {
    comments = "italic",
    keywords = "italic",
    functions = "italic",
    strings = "bold",
  },
  highlights = {
    ["@include"] = { fg = "$purple", fmt = "italic" },
    FloatBorder = { fg = "$grey", bg = "$bg0" }
  },
  diagnostics = {
    background = false
  }
}

onedark.load()
