local wk = require("which-key")
local tools = require("tools")

local c = function(raw)
  return "<cmd>" .. raw .. "<CR>"
end

local mapping = {
  s = {
    name = "Save or Screen",
    a = { c("wa"), "Save All Buffer" }
  },
  e = { c("NvimTreeToggle"), "Toggle NvimTree" },
  c = { 
    function()
      tools.close_buffer()
    end,
    "Close Buffer"
  },
  z = {},
  g = {}
}

wk.setup {
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
    border = "single"
  },
  show_help = false,
  disable = {
    filetypes = { "TelescopePrompt" }
  }
}

wk.register(
  mapping,
  {
    prefix = "<leader>"
  }
)
