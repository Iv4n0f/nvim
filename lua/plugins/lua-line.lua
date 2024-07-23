return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
    -- Linea de estatus inferior
		require("lualine").setup({
			options = {
				theme = "catppuccin",
			},
		})
	end,
}
