local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
	ensure_installed = {
		"c",
		"lua",
		"javascript",
		"typescript",
		"scss",
		"html",
		"python",
		"tsx",
		"css",
		"vue",
		"markdown",
		"markdown_inline",
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
		disable = function(lang, buf)
			local max_filesize = 20 * 1024 -- 20 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
	indent = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	autotag = {
		enable = true,
	},
})

-- 打开文件时，禁止折叠功能
if false then
	vim.api.nvim_create_autocmd({
		"BufEnter",
	}, {
		pattern = { "*" },
		command = "normal zR",
	})
end
