-- Python interpreter lookup shared by the LSP, DAP and neotest setups (macOS and Omarchy).
-- Order: an activated venv ($VIRTUAL_ENV, also what :VenvSelect sets), then .venv/ or venv/ in the
-- project root (uv, poetry with in-project venvs, `python -m venv`), then python3 on PATH.
local M = {}

local function exe(path)
  return path and vim.fn.executable(path) == 1 and path or nil
end

---@param root? string project root, defaults to the current directory
---@return string? python of the project's virtualenv, nil when there is none
function M.venv_python(root)
  if vim.env.VIRTUAL_ENV then
    local py = exe(vim.env.VIRTUAL_ENV .. "/bin/python")
    if py then
      return py
    end
  end
  root = root or vim.fn.getcwd()
  for _, dir in ipairs({ ".venv", "venv" }) do
    local py = exe(root .. "/" .. dir .. "/bin/python")
    if py then
      return py
    end
  end
end

---@param root? string
---@return string interpreter to run project code with
function M.python(root)
  return M.venv_python(root) or exe(vim.fn.exepath("python3")) or "python3"
end

---@return string interpreter that has debugpy: mason's copy, else the project's
function M.debugpy_python()
  return exe(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python") or M.python()
end

return M
