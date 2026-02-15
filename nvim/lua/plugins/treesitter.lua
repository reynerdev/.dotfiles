return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		-- build = function()
		-- 	require("nvim-treesitter.install").update({ with_sync = true })
		-- end,
		config = function()
			---@diagnostic disable: missing-fields
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
				},
				sync_install = false,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
					disable = { "ocaml", "ocaml_interface" },
				},
				autopairs = {
					enable = true,
				},
				autotag = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<c-backspace>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})

			local ts_autostart_group = vim.api.nvim_create_augroup("treesitter-autostart", { clear = true })

			local function start_ts(buf)
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end
				if vim.bo[buf].buftype ~= "" then
					return
				end

				local ft = vim.bo[buf].filetype
				if ft == "" then
					local name = vim.api.nvim_buf_get_name(buf)
					local detected = vim.filetype.match({ buf = buf, filename = name })
					if detected and detected ~= "" then
						vim.bo[buf].filetype = detected
						ft = detected
					end
				end
				if ft == "" then
					return
				end

				pcall(vim.treesitter.start, buf)
			end

			vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufWinEnter", "BufReadPost", "BufNewFile" }, {
				group = ts_autostart_group,
				callback = function(args)
					start_ts(args.buf)
				end,
			})

			start_ts(vim.api.nvim_get_current_buf())

			vim.api.nvim_create_autocmd("VimEnter", {
				group = ts_autostart_group,
				once = true,
				callback = function()
					vim.schedule(function()
						start_ts(vim.api.nvim_get_current_buf())
						vim.defer_fn(function()
							start_ts(vim.api.nvim_get_current_buf())
						end, 25)
					end)
				end,
			})
		end,
	},
	{
		-- Additional text objects for treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local tsc = require("treesitter-context")

			tsc.setup({
				enable = false,
				max_lines = 1,
				trim_scope = "inner",
			})
		end,
	},
}
