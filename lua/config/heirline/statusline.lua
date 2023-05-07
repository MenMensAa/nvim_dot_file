local nvim_web_devicons = require("nvim-web-devicons")
local conditions = require("heirline.conditions")
local tools = require("tools")

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
      callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
    },
  },
  {
    provider = "",  -- right icon: 
    hl = function(self)
      return { fg = get_mode_color(self.mode), bg = align_fill_bg }
    end
  }
}

local DiagnosticsInfo = {
  condition = conditions.has_diagnostics,
  init = function(self)
    self.diagnostic = tools.get_diagnostics_info()
  end,
  update = { "DiagnosticChanged", "BufEnter" },
  hl = { bg = align_fill_bg },
  {
    provider = function(self)
      return self.diagnostic.errors > 0 and (" " .. self.diagnostic.errors .. " ")
    end,
    hl = { fg = "red" }
  },
  {
    provider = function(self)
      return self.diagnostic.warnings > 0 and (" " .. self.diagnostic.warnings .. " ")
    end,
    hl = { fg = "yellow" }
  },
  {
    provider = function(self)
      return self.diagnostic.hints > 0 and (" " .. self.diagnostic.hints .. " ")
    end,
    hl = { fg = "purple" }
  },
  {
    provider = function(self)
      return self.diagnostic.info > 0 and (" " .. self.diagnostic.info.. " ")
    end,
    hl = { fg = "blue" }
  },
}

local LSPInfo = {
  update = {
    "LspAttach",
    "LspDetach",
    "BufEnter",
    callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end)
  },
  provider = function()
    local names = {}
    for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      table.insert(names, server.name)
    end
    if #names == 0 then
      return ""
    end
    return " [" .. table.concat(names, ",") .. "] "
  end,
  hl = { fg = "green", bg = align_fill_bg, bold = true }
}

local FileInfo = {
  init = function(self)
    local filepath = vim.api.nvim_buf_get_name(0)
    self.filename = vim.fn.fnamemodify(filepath, ":t")
    self.extension = vim.fn.fnamemodify(filepath, ":e")
    self.icon, self.icon_color = nvim_web_devicons.get_icon_color(self.filename, self.extension, { defualt = true })
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
  DiagnosticsInfo,
  LSPInfo,
  FileInfo,
  LineInfo
}
