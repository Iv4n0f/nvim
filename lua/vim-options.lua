-- Se recomienda remapear BlockMayus como <Esc> a nivel de sistema o hardware
-- KDE tiene esta opción en las configuraciones
-- para sesiones X11 ->  setxkbmap -option "caps:escape"

--Tabzise
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

--Clipboard por defecto a clipboard del sistema(xclip required)
vim.cmd("set clipboard=unnamedplus")

--Desactivar el mouse
vim.cmd("set mouse = ")

--Leader key en la barra espaciadora
vim.g.mapleader = " "
vim.opt.swapfile = false
vim.opt.scrolloff = 99

--Dejar de resaltar la búsqueda "/"
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

--Copiar todo el archivo(buffer) actual al clipboard por defecto
vim.keymap.set("n", "<leader>ya", "ggVGy<C-o>")

--  al presionar {{ en insert mode se crea esta estructura
--  {
--    cursor termina aquí en insert mode
--  }
vim.keymap.set("i", "{{", "{<CR>}<Esc>O")

--Evitar dolores de cabeza
vim.cmd("nnoremap q: <nop>")
vim.cmd("nnoremap Q <nop>")

--Numeros de linea abolsutos y relativos
vim.wo.number = true
vim.wo.relativenumber = true
