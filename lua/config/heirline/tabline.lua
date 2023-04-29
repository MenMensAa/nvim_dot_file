local utils = require("heirline.utils")
local nvimWebDevicons = require("nvim-web-devicons")

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

-- this is the default function used to retrieve buffers
local get_bufs = function()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_get_option(bufnr, "buflisted")
  end, vim.api.nvim_list_bufs())
end

local get_buf_neighbour = function(bufnr)
  local buf, prev_buf, next_buf = nil, nil, nil
  for i, v in ipairs(get_bufs()) do
    if v == bufnr then
      prev_buf = buf
    end
    if buf == bufnr then
      next_buf = v
    end
    buf = v
  end
  return prev_buf, next_buf
end

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
      local is_modified = vim.api.nvim_buf_get_option(minwid, "modified")
      if not is_modified then
        vim.schedule(function()
          local active_bufnr = vim.api.nvim_get_current_buf()
          if active_bufnr == minwid then
            local prev_buf, next_buf = get_buf_neighbour(minwid)
            local target_buf = prev_buf or next_buf
            if target_buf ~= nil then
              vim.api.nvim_win_set_buf(0, target_buf)
            else
              vim.api.nvim_command("close")
            end
          end
          vim.api.nvim_buf_delete(minwid, { force = false })
          vim.cmd.redrawtabline()
        end)
      end
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

