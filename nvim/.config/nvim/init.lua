-- init.lua

vim.g.lsp_servers = {
    "bashls",
    "emmet_ls",
    --"grammarly",
    "jsonls",
    "sumneko_lua",
    "tsserver",
    "yamlls",
    "cssls",
    "html",
    "intelephense",
}

-- Vim native options. Make it more modern
require("options")

-- All keymaps in one file for easier research
require("keymaps")

-- Vim commands and autocommands
require("commands")

-- Plugins and plugin configuration
require("plugins")

-- "Try" to setup the color scheme
 --vim.cmd([[silent! colorscheme nightfox]])

-- Possible values: storm, night and day
 --vim.g.tokyonight_style = "day"
 --vim.cmd[[silent! colorscheme tokyonight]]

 --vim.g.material_style = "darker" -- Possible values: palenight, oceanic, deep ocean, darker, ligher
 --vim.cmd([[silent! colorscheme material]])

-- vim.g.oceanic_transparent_bg = 1
-- vim.g.oceanic_italic_comments = 1
-- vim.cmd[[silent! colorscheme oceanicnext]]

-- vim.cmd([[silent! colorscheme github_dimmed]])

vim.g.nord_italic = false
vim.cmd[[colorscheme nord]]
