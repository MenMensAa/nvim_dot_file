local tools = require("tools")

local default_keymaps = {
  insert_mode = {
    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-j>"] = "<Esc>:m .+1<CR>==gi",
    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-k>"] = "<Esc>:m .-2<CR>==gi",
    -- 快速切换buffer
    ["<A-h>"] = ":bprev<CR>",
    ["<A-l>"] = ":bnext<CR>",
  },

  normal_mode = {
    -- Better window movement
    ["<C-h>"] = "<C-w>h",
    ["<C-j>"] = "<C-w>j",
    ["<C-k>"] = "<C-w>k",
    ["<C-l>"] = "<C-w>l",

    -- Resize with arrows
    ["<C-Up>"] = ":resize -2<CR>",
    ["<C-Down>"] = ":resize +2<CR>",
    ["<C-Left>"] = ":vertical resize -2<CR>",
    ["<C-Right>"] = ":vertical resize +2<CR>",

    -- Move current line / block with Alt-j/k a la vscode.
    ["<A-j>"] = "4j",
    ["<A-k>"] = "4k",

    -- 快速切换buffer
    ["<A-h>"] = ":bprev<CR>",
    ["<A-l>"] = ":bnext<CR>",
  },

  term_mode = {
    -- Terminal window navigation
    ["<C-h>"] = "<C-\\><C-N><C-w>h",
    ["<C-j>"] = "<C-\\><C-N><C-w>j",
    ["<C-k>"] = "<C-\\><C-N><C-w>k",
    ["<C-l>"] = "<C-\\><C-N><C-w>l",
  },

  visual_mode = {
    -- Better indenting
    ["<"] = "<gv",
    [">"] = ">gv",
  },

  visual_block_mode = {
    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-j>"] = ":m '>+1<CR>gv-gv",
    ["<A-k>"] = ":m '<-2<CR>gv-gv",
  },

  command_mode = {
    -- navigate tab completion with <c-j> and <c-k>
    -- runs conditionally
    ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
    ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
  },
}

-- lsp相关按键绑定
local lsp_keymaps = {
  ["K"] = "Lspsaga hover_doc ++quiet",
  ["gf"] = "lua vim.lsp.buf.formatting()",
  ["gr"] = "Telescope lsp_references include_current_line=true ",
  ["gd"] = "Lspsaga goto_definition",
  ["gp"] = "Lspsaga peek_definition",
  ["gt"] = "Lspsaga goto_type_definition",
  ["gD"] = "lua vim.lsp.buf.declaration()",
  ["gi"] = "lua vim.lsp.buf.implementation()",
  ["gR"] = "Lspsaga rename",
  ["ga"] = "Lspsaga code_action",
  ["go"] = "Lspsaga show_line_diagnostics ++unfocus",
  ["g]"] = "lua vim.diagnostic.goto_next()",
  ["g["] = "lua vim.diagnostic.goto_prev()",
}

local cmd = function(raw)
  return "<cmd>" .. raw .. "<CR>"
end

local which_keymaps = {
  s = {
    name = "Save or Screen",
    a = { cmd("wa"), "Save All Buffer" }
  },
  f = {
    name = "Find",
    t = { cmd("Telescope live_grep"), "Find Text" },
    f = { cmd("Telescope find_files"), "Find File" },
  },
  e = { cmd("NvimTreeToggle"), "Toggle NvimTree" },
  c = {
      tools.close_buffer,
    "Close Buffer"
  },
  h = { cmd("set nohlsearch"), "No Highlight" },
  l = {
    name = "LSP",
    b = { cmd("Lspsaga show_buf_diagnostics"), "Show Buf Diagnostics" },
    w = { cmd("Lspsaga show_workspace_diagnostics"), "Show Workspace Diagnostics" }
  },
  g = {
    name = "Git",
    g = {
      tools.toggle_lazygit,
      "Lazygit"
    }
  }
}

-- leader key 为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode = generic_opts_any,
  operator_pending_mode = generic_opts_any,
  term_mode = { silent = true },
}

local mode_adapters = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
  operator_pending_mode = "o",
}

function M.bind_keymaps()
  for mode, mapping in pairs(default_keymaps) do
    local format_mode = mode_adapters[mode] or mode
    for key, val in pairs(mapping) do
      local opt = generic_opts[format_mode] or generic_opts_any
      if type(val) == "table" then
        opt = val[2]
        val = val[1]
      end
      if val then
        vim.keymap.set(format_mode, key, val, opt)
      end
    end
  end
end

function M.bind_lsp_keymaps(bufnr)
  for key, action in pairs(lsp_keymaps) do
    if type(action) == "string" then
      vim.api.nvim_buf_set_keymap(bufnr, "n", key, cmd(action), generic_opts_any)
    end
  end
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

function M.bind_cmp_keymaps(cmp, luasnip)
  local SELECT = cmp.SelectBehavior.Select
  local INSERT = cmp.SelectBehavior.Insert
  return {
    ["Up"] = cmp.mapping.select_prev_item { behavior = SELECT },
    ["Down"] = cmp.mapping.select_next_item { behavior = SELECT },
    ["<C-k>"] = cmp.mapping.select_prev_item { behavior = INSERT },
    ["<C-j>"] = cmp.mapping.select_next_item { behavior = INSERT },
    ["<CR>"] = cmp.mapping.confirm { select = false },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
}
end

function M.bind_which_keymaps()
  return which_keymaps
end

return M
