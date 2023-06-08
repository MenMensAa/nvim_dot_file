local wk = require("which-key")
local keybindings = require("keybindings")

wk.setup({
	plugins = {
		presets = {
			operators = false,
			motions = false,
			text_objects = false,
			windows = false,
			nav = false,
			g = false,
		},
	},
	window = {
		border = "single",
	},
	show_help = false,
	disable = {
		filetypes = { "TelescopePrompt" },
	},
})

wk.register(keybindings.bind_which_keymaps(), {
	prefix = "<leader>",
})
