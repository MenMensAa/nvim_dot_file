local function get_config(conf_path)
  return function()
    local full_path = "config." .. conf_path
    require(full_path)
  end
end

local plugins_config = {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    config = get_config("colorscheme")
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true
  },

  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = get_config("nvim-tree")
  },

  {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    config = get_config("heirline")
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = get_config("which-key")
  },

  -- tree-sitter plugins
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = get_config("treesitter")
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = get_config("ts-autotag")
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = get_config("autopairs")
  },

  -- lsp plugins
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = get_config("mason")
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = get_config("mason-lsp")
  },
  {
    "neovim/nvim-lspconfig",  -- collection of configuration for built-in lsp client
    lazy = true,
    dependencies = { "williamboman/mason-lspconfig.nvim", "williamboman/mason.nvim" }
  },

  -- cmp plugins
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = get_config("cmp-luasnip")
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim"
    },
    event = "InsertEnter",
    config = get_config("cmp")
  },
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugins_config)

