local utils = require("heirline.utils")
local nvimWebDevicons = require("nvim-web-devicons")

local active_text_color = "fg"
local deactive_text_color = "bg5"

local active_bg = "bg0"
local deactive_bg = "bg_d"

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
      if self.is_modified then
        return
      end
      vim.schedule(function()
        vim.api.nvim_buf_delete(minwid, { force = false })
      end)
      vim.cmd.redrawtabline()
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

local Bufferline = utils.make_buflist(
BufferlineComponent
)

return Bufferline

