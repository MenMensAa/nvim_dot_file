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
  ["K"] = "vim.lsp.buf.hover()",
  ["gf"] = "vim.lsp.buf.formatting()",
  ["gr"] = "vim.lsp.buf.references()",
  ["gd"] = "vim.lsp.buf.definition()",
  ["gD"] = "vim.lsp.buf.declaration()",
  ["gi"] = "vim.lsp.buf.implementation()",
  ["gt"] = "vim.lsp.buf.type_definition()",
  ["gR"] = "vim.lsp.buf.rename()",
  ["ga"] = "vim.lsp.buf.code_action()",
  ["go"] = "vim.diagnostic.open_float()",
  ["g]"] = "vim.diagnostic.goto_next()",
  ["g["] = "vim.diagnostic.goto_prev()",
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
      vim.api.nvim_buf_set_keymap(bufnr, "n", key, "<cmd>lua " .. action .. "<CR>", generic_opts_any)
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


return M
