local statusline = require("config.heirline.statusline")
local tabline = require("config.heirline.tabline")
local palette = require("palette")

require("heirline").setup({
	statusline = statusline,
	tabline = tabline,

	opts = {
		colors = palette,
	},
})
