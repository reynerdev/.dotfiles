return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = "master",
  build = ':TSUpdate',
  config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"css",
				"gleam",
				"go",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"ocaml",
				"ocaml_interface",
				"rust",
				"svelte",
				"terraform",
				"tsx",
				"typescript",
				"vimdoc",
				"yaml",
			}
		})
	end
}
