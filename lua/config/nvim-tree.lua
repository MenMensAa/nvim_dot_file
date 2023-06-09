local nvim_tree = require("nvim-tree")

nvim_tree.setup({
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	view = {
		width = 35,
		side = "left",
	},
	renderer = {
		root_folder_label = false,
		highlight_git = true,
		indent_width = 2,
		indent_markers = {
			enable = true,
		},
		icons = {
			show = {
				git = false,
			},
		},
	},
	git = {
		ignore = false,
	},
	filters = {
		custom = { "^.git$" },
	},
})

local function open_nvim_tree(data)
	-- buffer is a real file on the disk
	local real_file = vim.fn.filereadable(data.file) == 1

	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	if not real_file and not no_name then
		return
	end

	-- open the tree, find the file but don't focus it
	require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
