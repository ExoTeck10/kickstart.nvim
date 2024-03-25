return {
  'jay-babu/mason-null-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'williamboman/mason.nvim',
    'nvimtools/none-ls.nvim',
  },
  config = function()
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    local null_ls = require 'null-ls'

    local sources = {
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.gofumpt,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.terraform_fmt,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.diagnostics.regal,
    }

    require('mason').setup()

    null_ls.setup {
      debug = true,
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds {
            group = augroup,
            buffer = bufnr,
          }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr }
            end,
          })
        end
      end,
    }

    require('mason-null-ls').setup {
      ensure_installed = nil,
      automatic_installation = true,
    }
  end,
}
