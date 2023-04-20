local onedark = require("onedark")

onedark.setup {
  style = "dark",
  -- transparent = true,
  code_style = {
    comments = "italic",
    keywords = "italic",
    functions = "italic",
    strings = "bold",
  },
  highlights = {
    ["@include"] = { fg = '$purple', fmt = "italic" },
  }
}

onedark.load()
