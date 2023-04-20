local nvimWebDevicons = require("nvim-web-devicons")

local mode_color_config = {
  n = "green",
  i = "blue",
  v = "purple",
  V =  "purple",
  ["\22"] =  "purple",
  c =  "orange",
  s =  "red",
  S =  "red",
  ["\19"] =  "purple",
  R =  "orange",
  r =  "orange",
  ["!"] =  "red",
  t =  "red", 
}

local function get_mode_color(mode)
  local format_mode = mode:sub(1, 1)
  return mode_color_config[format_mode]
end

local align_fill_bg = "bg1"
local file_info_bg = "bg4"

local Align = { provider = "%=", hl = { bg = align_fill_bg } }

local ViMode = {
  static = {
    mode_names = { 
      n = "normal",
      no = "normal",
      nov = "normal",
      noV = "normal",
      ["no\22"] = "normal",
      niI = "normal",
      niR = "normal",
      niV = "normal",
      nt = "normal",
      v = "virtual",
      vs = "virtual",
      V = "virtual",
      Vs = "virtual",
      ["\22"] = "virtual",
      ["\22s"] = "virtual",
      s = "select",
      S = "select",
      ["\19"] = "select",
      i = "insert",
      ic = "insert",
      ix = "insert",
      R = "replace",
      Rc = "replace",
      Rx = "replace",
      Rv = "replace",
      Rvc = "replace",
      Rvx = "replace",
      c = "command",
      cv = "command",
      r = "remove",
      rm = "remove",
      ["r?"] = "remove",
      ["!"] = "shell",
      t = "terminal",
    },
  },
  {
    provider = function(self)
      return " " .. string.upper(self.mode_names[self.mode]) .. " "
    end,
    hl = function(self)
      return { bg = get_mode_color(self.mode), fg = "black" ,bold = true, }
    end,
    update = {
      "ModeChanged",
      pattern = "*:*",
      callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
      end),
    },
  },
  {
    provider = "",  -- right icon: 
    hl = function(self)
      return { fg = get_mode_color(self.mode), bg = align_fill_bg }
    end
  }
}

local FileInfo = {
  init = function(self)
    local filepath = vim.api.nvim_buf_get_name(0)
    self.filename = vim.fn.fnamemodify(filepath, ":t")
    self.extension = vim.fn.fnamemodify(filepath, ":e")
    self.icon, self.icon_color = nvimWebDevicons.get_icon_color(self.filename, self.extension, { defualt = true })
  end,
  { provider = "", hl = { fg = file_info_bg, bg = align_fill_bg } },
  {
    hl = { bg = file_info_bg },
    {
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
    },
    { 
      provider = function(self)
        return self.filename .. " "
      end,
      hl = { fg = "fg" }
    }
  }
}

local LineInfo = {
  {
    provider = "",
    hl = function(self)
      return { fg = get_mode_color(self.mode), bg = file_info_bg }
    end
  },
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %p = percentage through file of displayed window
  -- %% = print %
  { 
    provider = "%7(%l/%L%) %4(%p%%%) ",
    hl = function(self)
      return { bg = get_mode_color(self.mode), fg = "black" }
    end
  },
}

return { 
  init = function(self)
   self.mode = vim.fn.mode(1)
  end,
  ViMode, 
  Align,
  FileInfo,
  LineInfo
}
