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

    use {
      "rebelot/heirline.nvim",
      event = "UiEnter",
      config = get_config("heirline")
    }

    use {
      "nvim-treesitter/nvim-treesitter",
      run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
      end,
      config = get_config("treesitter")
    }

    use {
      "windwp/nvim-ts-autotag",
      dependencies = "nvim-treesitter/nvim-treesitter",
      config = get_config("ts-autotag")
    }

    use {
      "windwp/nvim-autopairs",
      config = get_config("autopairs")
    }

    use {
      "folke/which-key.nvim",
      config = get_config("which-key")
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
