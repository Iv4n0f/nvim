return {
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = { "stylua", "prettier", "clang_format", "pretty_php", "black" },
      })
    end,
  },
  {
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
          -- rust-analyzer ya tiene una funcion de formateo integrada
          -- no es necesario añadirla aquí
        },
      })

      -- Dar formato al buffer actual
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
  },
}
