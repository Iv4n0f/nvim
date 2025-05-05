vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.swapfile = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 7

vim.g.mapleader = " "
vim.opt.mouse = ""

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("i", "{{", "{<CR>}<Esc>O", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })
vim.keymap.set("n", "<leader>q", "<cmd>cclose<CR>", { silent = true, desc = "Cerrar quickfix list" })
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
