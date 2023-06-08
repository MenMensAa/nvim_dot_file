local null_ls = require("null-ls")
local cspell = require("cspell")
local tools = require("tools")

local formatters = null_ls.builtins.formatting
local linters = null_ls.builtins.diagnostics

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		--[[ cspell.diagnostics.with({
			diagnostics_postprocess = function(diagnostic)
				diagnostic.severity = vim.diagnostic.severity.HINT
			end,
		}),
		cspell.code_actions, ]]
		formatters.stylua,
		formatters.prettier.with({
			prefer_local = "node_modules/.bin",
		}),
		linters.eslint.with({
			only_local = "node_modules/.bin",
		}),
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
					tools.formatting(bufnr)
				end,
			})
		end
	end,
})
