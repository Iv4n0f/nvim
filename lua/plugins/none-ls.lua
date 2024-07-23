return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- Instalar formatters con :Mason y agregarlos a este archivo
        -- reemplazar "_" por "-"
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.pretty_php,
        null_ls.builtins.formatting.black,
      },
    })

    -- Dar formato al buffer actual
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
