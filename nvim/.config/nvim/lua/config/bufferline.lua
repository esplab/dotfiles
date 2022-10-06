-- config/bufferline.lua

require("bufferline").setup({
    options = {
        offsets = {{filetype = "NvimTree", text = "File Explorer"}},
    },
    highlights = {
    -- 	background = {					-- inactive tab color
    -- 		guifg = comment_fg,
    -- 		guibg = "#282c34"
    -- 	},
        buffer_selected = {				-- active tab color
    -- 		guifg = normal_fg,
    -- 		guibg = "#3A3E44",
     		italic = false
        },
    -- 	fill = {						-- bufferline's background color
    -- 		guifg = comment_fg,
    -- 		guibg = "#282c34"
    -- 	},
    -- 	separator_visible = {
    -- 		guifg = "#282c34",
    -- 		guibg = "#282c34"
    -- 	},
    -- 	separator_selected = {
    -- 		guifg = "#282c34",
    -- 		guibg = "#282c34"
    -- 	},
    -- 	separator = {						-- separator color. first one is the thin line; second one is the thick one
    -- 		guifg = "#393b43",
    -- 		guibg = "#282c34"
    -- 	},
    -- 	indicator_selected = {				-- separator when tab is active color
    -- 		guifg = "#1da8f2",
    -- 		guibg = "#3A3E44"
    -- 	},
    -- 	modified_selected = {				-- color when modified right hand side of the tab
    -- 		guifg = string_fg,
    -- 		guibg = "#3A3E44"
    -- 	}
    }
})
