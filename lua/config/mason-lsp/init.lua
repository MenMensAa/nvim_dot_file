local language_server = {
  lua = { "lua_ls" },
  css = { "cssls", "cssmodules_ls" },
  html = { "html" },
  javascript = { "tsserver" },
  python = { "pyright" },
  vue = { "volar" }
}

local ensure_installed = {}

for _, server_names in pairs(language_server) do
  for _, server in pairs(server_names) do
    table.insert(ensure_installed, server)
  end
end

require("mason-lspconfig").setup({
  ensure_installed = ensure_installed
})

local lspconfig = require("lspconfig")
local bind_lsp_keymaps = require("keybindings").bind_lsp_keymaps

for file_name, server_names in pairs(language_server) do
  local status_ok, config = pcall(require, "config.mason-lsp." .. file_name)
  if status_ok then
    for _, server in pairs(server_names) do
      local setup_config = config[server] or config
      local origin_on_attach = setup_config.on_attach
      setup_config.on_attach = function(client, bufnr)
        if origin_on_attach then
          origin_on_attach(client, bufnr)
        end
        bind_lsp_keymaps(bufnr)
      end
      lspconfig[server].setup(setup_config)
    end
  end
end

