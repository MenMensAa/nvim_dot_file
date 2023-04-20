local conditions = require("heirline.conditions")
local statusline = require("config.heirline.statusline")
local bufferline = require("config.heirline.bufferline")
local palette = require("palette")

require("heirline").setup({
  statusline = statusline,
  tabline = bufferline,

  opts = {
    colors = palette
  }
})
