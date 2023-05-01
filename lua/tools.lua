local tools = {}

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

function tools.close_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local is_modified = vim.api.nvim_buf_get_option(bufnr, "modified")
  if not is_modified then
    vim.schedule(function()
      local active_bufnr = vim.api.nvim_get_current_buf()
      if active_bufnr == bufnr then
        local prev_buf, next_buf = get_buf_neighbour(bufnr)
        local target_buf = prev_buf or next_buf
        if target_buf ~= nil then
          vim.api.nvim_win_set_buf(0, target_buf)
        else
          vim.api.nvim_command("close")
        end
      end
      vim.api.nvim_buf_delete(bufnr, { force = false })
      vim.cmd.redrawtabline()
    end)
  end
end

return tools