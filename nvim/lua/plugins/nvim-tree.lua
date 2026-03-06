return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				sort_by = "name",
				view = {
					side = "right",
					adaptive_size = true,
					width = 32,
				},
				update_focused_file = {
					enable = true,
					update_root = {
						enable = false,
					},
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = false,
				},
			})
		end,
	},
}
