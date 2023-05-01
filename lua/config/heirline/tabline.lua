local heirline_utils = require("heirline.utils")
local nvimWebDevicons = require("nvim-web-devicons")
local tools = require("tools")

local active_text_color = "fg"
local deactive_text_color = "bg5"

local active_bg = "bg3"
local deactive_bg = "bg_l"

local BufferlineFileName = {
  provider = function(self)
    local filename = self.filename
    filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
    return filename
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true, }
  end,
}

local BufferlineFileIcon = {
  provider = function(self)
    if (self.icon) then
      return " " .. self.icon .. " "
    else
      return " "
    end
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local BufferlineContent = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    self.icon, self.icon_color = nvimWebDevicons.get_icon_color(self.filename, self.extension, { defualt = true })
  end,
  hl = function(self)
    if self.is_active then
      return { fg = active_text_color, bg = active_bg }
    else
      return { fg = deactive_text_color, bg = deactive_bg }
    end
  end,
  on_click = {
    callback = function(_, minwid)
      vim.api.nvim_win_set_buf(0, minwid)
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = "heirline_tabline_buffer_callback"
  },
  BufferlineFileIcon,
  BufferlineFileName
}

local BufferlineButton = {
  init = function(self)
    self.is_modified = vim.api.nvim_buf_get_option(self.bufnr, "modified")
  end,
  provider = function(self)
    if self.is_modified then
      return " "
    else
      return " 󰖭"
    end
  end,
  hl = function(self)
    local fg = active_text_color
    if self.is_modified then
      fg = "yellow"
    elseif not self.is_active then
      fg = deactive_text_color
    end
    return { fg = fg }
  end,
  on_click = {
    callback = function(self, minwid)
      tools.close_buffer(minwid)
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = "heirline_tabline_close_buffer_callback",
  },
}

local BufferlineComponent = {
  hl = function(self)
    if self.is_active then
      return { bg = active_bg }
    else
      return { bg = deactive_bg }
    end
  end,
  { 
    provider = function(self)
      if self.is_active then 
        return " ◉"
      else
        return "  "
      end
    end,
    hl = { fg = "green" }
  },
  BufferlineContent,
  BufferlineButton,
  { provider = "  " }
}

local Bufferline = heirline_utils.make_buflist(
BufferlineComponent
)

local BufferlineOffset = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win

    if vim.bo[bufnr].filetype == "NvimTree" then
      return true
    end
  end,
  provider = function(self)
    local width = vim.api.nvim_win_get_width(self.winid)
    local padding_string = string.rep(" ", width)
    return padding_string
  end,
  hl = { bg = "bg_d" }
}

return { BufferlineOffset, Bufferline }

