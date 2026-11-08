-- return {
--   {
--     "dgox16/oldworld.nvim",
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme("oldworld")
--     end,
--   },
-- }

return {
  "ribru17/bamboo.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("bamboo").setup({
      -- optional configuration here
    })
    require("bamboo").load()
  end,
}

-- Other possible themes
-- I. Oldworld
-- "dgox16/oldworld.nvim",
--vim.cmd.colorscheme("oldworld")
--
-- II. Moonfly
--  "bluz71/vim-moonfly-colors"
-- return {
--   {
--     "bluz71/vim-moonfly-colors",
--     name = "moonfly",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme("moonfly")
--     end,
--   },
-- }
-- vim.cmd.colorscheme("moonfly")
--
-- III. Onedark
-- "olimorris/onedarkpro.nvim"
-- vim.cmd.colorscheme("onedark_dark")
--
-- IV. Sonokai
-- return {
--   "sainnhe/sonokai",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.g.sonokai_enable_italic = true
--     vim.g.sonokai_style = "maia"
--     vim.cmd.colorscheme("sonokai")
--   end,
-- }

-- V. Nightfly
-- return {
--   "bluz71/vim-nightfly-colors",
--   name = "nightfly",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("nightfly")
--   end,
-- }
