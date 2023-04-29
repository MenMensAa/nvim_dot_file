local packer = require("packer")

local function get_config(configPath)
  return "require('config." .. configPath .. "')"
end

packer.startup({
  function(use)
    use "wbthomason/packer.nvim"

    use {
      "navarasu/onedark.nvim",
      config = get_config("colorscheme")
    }

    use {
      "nvim-tree/nvim-tree.lua",
      requires = {
        "nvim-tree/nvim-web-devicons", -- optional
      },
      config = get_config("nvim-tree")
    }

    -- use {
    --  "tamton-aquib/staline.nvim",
    --  config = getConfig("staline")
    -- }
    
    use {
      "rebelot/heirline.nvim",
      event = "UiEnter",
      config = get_config("heirline")
    }
  end,
  config = {
    max_jobs = 16,
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end
    }
  }
})
