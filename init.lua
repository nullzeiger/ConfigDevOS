-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Set the update time for CursorHold to trigger more quickly
vim.opt.updatetime = 300
vim.cmd [[
augroup HoverDiagnostics
  autocmd!
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})
augroup END
]]

-- Colorscheme
vim.cmd('colorscheme torte')

-- For LSP Error Warning
vim.opt.signcolumn = 'yes'

-- Autocomplete menu
vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Save cursor position
vim.api.nvim_create_autocmd('BufRead', {
  desc = 'Save last position cursor',
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match('commit') and ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

-- Go LSP
local on_attach = function(client, bufnr)
   vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
   vim.api.nvim_buf_set_keymap(0, 'i', '<C-Space>', '<C-x><C-o>', { noremap = true, silent = true })
end

-- Register gopls (only once)
if not vim.lsp.config.gopls then
  vim.lsp.config.gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.mod", ".git" },
  }
end

-- Start server for this buffer
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gowork", "gotmpl" },
  callback = function(args)
    vim.lsp.start({
      name = "gopls",
      cmd = { "gopls" },
      root_dir = vim.fs.root(args.buf, { "go.mod", ".git" }),
      on_attach = on_attach,

      settings = {
        gopls = {
          gofumpt = true,
          staticcheck = true,
          analyses = {
            unusedparams = true,
          },
        },
      },
    })
  end,
})

-- Autocommand to organize imports and format before saving a Go file
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = 'Imports and Formatting',
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)

    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
