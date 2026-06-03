-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Base config
vim.g.mapleader = " "

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.swapfile = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 7

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("i", "{{", "{<CR>}<Esc>O", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })
vim.keymap.set("n", "<leader>q", "<cmd>cclose<CR>", { silent = true, desc = "Close quickfix list" })
vim.keymap.set("n", "q:", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "Q", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ya", "ggVGy<C-o>")

vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy",
    ["*"] = "wl-copy",
  },
  paste = {
    ["+"] = "wl-paste --no-newline",
    ["*"] = "wl-paste --no-newline",
  },
}

vim.cmd [[
cnoreabbrev <expr> man getcmdtype() == ':' && getcmdline() ==# 'man' ? 'Man' : 'man'
]]

vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    prefix = "●",
  },
})

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "rose-pine/neovim",
      name = "rose-pine",

      config = function()
        require("rose-pine").setup({
          variant = "main",
          dark_variant = "main",

          dim_inactive_windows = false,
          extend_background_behind_borders = true,

          enable = {
            terminal = true,
            legacy_highlights = true,
            migrations = true,
          },

          styles = {
            bold = true,
            italic = false,
            transparency = true,
          },
        })

        vim.cmd("colorscheme rose-pine-main")
      end,
    },
    {
      "nvim-telescope/telescope.nvim",

      dependencies = {
        "nvim-lua/plenary.nvim",
      },

      config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>ff", builtin.find_files)
        vim.keymap.set("n", "<C-f>", builtin.git_files)
        vim.keymap.set("n", "<leader>F", builtin.live_grep)
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter").setup({
          ensure_installed = {
            "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline"
          },
          sync_install = false,
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
        })
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("nvim-treesitter-textobjects").setup({
          select = {
            lookahead = true,
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"]  = "V",
              ["@class.outer"]     = "V",
            },
            include_surrounding_whitespace = true,
          },
        })

        local select = require("nvim-treesitter-textobjects.select")

        local keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        }

        for key, query in pairs(keymaps) do
          vim.keymap.set({ "x", "o" }, key, function()
            select.select_textobject(query, "textobjects")
          end, { desc = "Select " .. query })
        end
      end,
    },
    {
      "numToStr/Comment.nvim",

      config = function()
        require("Comment").setup()
      end,
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
      },
      config = function()
        vim.opt.signcolumn = 'no'

        local cmp = require('cmp')
        cmp.setup({
          sources = {
            { name = 'nvim_lsp' },
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
            ['<CR>']  = cmp.mapping.confirm({ select = true }),
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
          }),
          snippet = {
            expand = function(args)
              vim.snippet.expand(args.body)
            end,
          },
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        vim.api.nvim_create_autocmd('LspAttach', {
          desc = 'LSP actions',
          callback = function(event)
            local opts = { buffer = event.buf }
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<leader>go', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>gs', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'x' }, '<leader>gf', function() vim.lsp.buf.format({ async = true }) end, opts)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          end,
        })
        vim.lsp.config("lua_ls", {
          capabilities = capabilities,
          settings = {
            Lua = {
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              }
            }
          }
        })
        vim.lsp.config("pyright", {
          capabilities = capabilities,
          root_markers = { "manage.py", ".git" },
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
                reportUnusedVariable = "none",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                extraPaths = { "." },
              },
            },
          },
        })

        vim.lsp.config("clangd", { capabilities = capabilities })
        vim.lsp.config("ruff", { capabilities = capabilities })

        vim.lsp.enable({ "clangd", "lua_ls", "pyright", "ruff" })
      end,
    },
  },
  checker = { enabled = true },
})
