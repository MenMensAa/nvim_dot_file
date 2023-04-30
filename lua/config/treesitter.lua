local treesitter = require('nvim-treesitter.configs')

treesitter.setup {
  ensure_installed = { 
    "c",
    "lua",
    "javascript",
    "html",
    "python",
    "tsx",
    "css",
    "vue"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  indent = {
    enable = true
  },
}
