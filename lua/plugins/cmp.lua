local Util = require("lazyvim.util")
return {
  { "saghen/blink.cmp", enabled = false },
  {
    "hrsh7th/nvim-cmp",
    -- enabled = false,
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      -- { "saadparwaiz1/cmp_luasnip" },
      -- {"onsails/lspkind.nvim"},
    },

    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
      opts.formatting.format = Util.inject.args(opts.formatting.format, function(entry, item)
        -- local litem = entry:get_completion_item()
        -- print(vim.inspect(litem))

        -- if litem.detail then
        --   item.menu = "🐷 " .. litem.detail
        -- end
      end)

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      -- cmp.register_source("ht_entity", require("gaomengnan.cmp.ht_entity").new())
      --
      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
      --   { name = "ht_entity" },
      -- }))

      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
        },
      })
      -- opts.window.completion = Util.inject.args(opts.window.completion, cmp.config.window.bordered)
      opts.window = {
        completion = cmp.config.window.bordered({
          border = "double",
          -- winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:MyCursorLine,Search:NONE"
        }),
        documentation = cmp.config.window.bordered(),
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
}
