return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local ls = require("luasnip")
			vim.keymap.set({ "i", "s" }, "<C-L>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-J>", function()
				ls.jump(-1)
			end, { silent = true })
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),

					-- Confirmar autocompletado linea comentada para confirmar con Enter
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
					-- ["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "crates" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
	-- Herramienta de crates para rust
	{
		"saecki/crates.nvim",
		tag = "stable",
		config = function()
			require("crates").setup({
				completion = {
					cmp = {
						enabled = true,
					},
					crates = {
						enabled = true,
						max_results = 8,
						min_chars = 3,
					},
				},
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			})
		end,
	},
}
