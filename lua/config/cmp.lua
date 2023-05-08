local cmp = require("cmp")
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local luasnip = require("luasnip")
local keybindings = require("keybindings")
local lspkind = require("lspkind")

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = keybindings.bind_cmp_keymaps(cmp, luasnip),
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = lspkind.cmp_format { mode = "symbol_text" }
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered()
  }
}

cmp.event:on(
  "confirm_done",
  cmp_autopairs.on_confirm_done()
)

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    {
      { name = 'path' }
    },
    {
      { name = 'cmdline' }
    }
  )
})
