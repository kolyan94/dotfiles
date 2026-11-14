-- Embedded development: Arduino sketches, PlatformIO (ESP32 / Pico) and Playdate.
--
-- PlatformIO projects are plain C/C++: run `pio run -t compiledb` once and the clangd from
-- lspconfig.lua picks up compile_commands.json. Arduino .ino sketches need arduino-language-server
-- (mason) plus arduino-cli (mise) and a sketch.yaml: `arduino-cli board attach -b <fqbn> x.ino`.
-- Playdate Lua uses lua_ls with a per-project .luarc.json written by :PlaydateLuarc.

local function sdk()
  local path = vim.env.PLAYDATE_SDK_PATH
  if not path or path == "" then
    path = vim.fn.expand("~/.local/share/playdate-sdk")
  end
  return vim.fn.isdirectory(path) == 1 and path or nil
end

-- Playdate Lua is 5.4 plus compound assignment (+= ...) and `import`. Point lua_ls at CoreLibs, and
-- at the playdate-luacats API stubs when cloned to ~/.local/share/playdate-luacats.
vim.api.nvim_create_user_command("PlaydateLuarc", function()
  local path = sdk()
  if not path then
    return vim.notify("Playdate SDK not found (PLAYDATE_SDK_PATH)", vim.log.levels.ERROR)
  end
  local library = { path .. "/CoreLibs" }
  local stubs = vim.fn.expand("~/.local/share/playdate-luacats")
  if vim.fn.isdirectory(stubs) == 1 then
    table.insert(library, stubs)
  end
  local luarc = {
    ["runtime.version"] = "Lua 5.4",
    ["runtime.nonstandardSymbol"] = { "+=", "-=", "*=", "/=", "//=", "%=", "<<=", ">>=", "&=", "|=", "^=" },
    ["runtime.special"] = { import = "require" },
    ["diagnostics.globals"] = { "playdate", "import" },
    ["workspace.library"] = library,
    ["workspace.checkThirdParty"] = false,
  }
  local file = vim.fn.getcwd() .. "/.luarc.json"
  vim.fn.writefile({ vim.json.encode(luarc) }, file)
  vim.notify("Wrote " .. file .. " (restart lua_ls with :LspRestart)")
end, { desc = "Playdate: write .luarc.json for lua_ls in the cwd" })

-- Build source/ into <cwd name>.pdx and open the simulator, in a terminal that shows pdc errors
vim.api.nvim_create_user_command("PlaydateRun", function()
  local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  Snacks.terminal(
    { "sh", "-c", 'pdc source "$1.pdx" && PlaydateSimulator "$1.pdx"', "pdrun", name },
    { auto_close = false }
  )
end, { desc = "Playdate: build and run in the simulator" })

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "arduino", "devicetree", "ini" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Needs the arduino-cli config (`arduino-cli config init`) and a core for the sketch's board
        arduino_language_server = {
          cmd = {
            "arduino-language-server",
            "-cli-config",
            vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
            "-clangd",
            "clangd",
          },
        },
      },
    },
  },
}
