-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function reload_recol()
  local path = vim.fn.stdpath("config") .. "/init.lua"
  local text = table.concat(vim.fn.readfile(path), "\n")
  local block = text:match("%-%- recol:start(.-)%-%- recol:end")

  if not block then
    vim.notify("Noch kein Recol-Theme vorhanden.", vim.log.levels.WARN)
    return
  end

  local apply, err = loadstring(block)
  if not apply then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  apply()
  vim.g.colors_name = "recol"
  vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "recol" })
end

vim.api.nvim_create_user_command("RecolReload", reload_recol, {})

vim.api.nvim_create_user_command("RecolOpen", function()
  if vim.fn.executable("recol") ~= 1 then
    vim.notify("recol wurde nicht im PATH gefunden.", vim.log.levels.ERROR)
    return
  end

  vim.cmd("botright 15new")
  local win = vim.api.nvim_get_current_win()
  vim.bo.bufhidden = "wipe"

  vim.fn.jobstart({
    "recol",
    "--target",
    "nvim",
    "-i",
    "--quit-on-select",
  }, {
    term = true,
    on_exit = function(_, code)
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
        if code == 0 then
          reload_recol()
        end
      end)
    end,
  })

  vim.cmd("startinsert")
end, {})

vim.keymap.set("n", "<leader>uR", "<cmd>RecolOpen<cr>", {
  desc = "Recol: Theme auswählen",
})
