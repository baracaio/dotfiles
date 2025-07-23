return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",

  config = function()
    require("nvim-surround").setup({
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },

      -- Surround configurations for different delimiters
      surrounds = {
        -- Default surrounds (can be customized)
        ["("] = {
          add = { "(", ")" },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a(" })
          end,
          delete = "^(.)().-(.)()$",
        },
        [")"] = {
          add = { "( ", " )" },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a)" })
          end,
          delete = "^(. ?)().-( ?.)()$",
        },
        ["{"] = {
          add = { "{", "}" },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a{" })
          end,
          delete = "^(.)().-(.)()$",
        },
        ["}"] = {
          add = { "{ ", " }" },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a}" })
          end,
          delete = "^(. ?)().-( ?.)()$",
        },
        ["<"] = {
          add = { "<", ">" },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a<" })
          end,
          delete = "^(.)().-(.)()$",
        },
        [">"] = {
          add = { "< ", " >" },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a>" })
          end,
          delete = "^(. ?)().-( ?.)()$",
        },
        ["["] = {
          add = { "[", "]" },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a[" })
          end,
          delete = "^(.)().-(.)()$",
        },
        ["]"] = {
          add = { "[ ", " ]" },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a]" })
          end,
          delete = "^(. ?)().-( ?.)()$",
        },
        ['"'] = {
          add = { '"', '"' },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = 'a"' })
          end,
          delete = "^(.)().-(.)()$",
        },
        ["'"] = {
          add = { "'", "'" },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a'" })
          end,
          delete = "^(.)().-(.)()$",
        },
        ["`"] = {
          add = { "`", "`" },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a`" })
          end,
          delete = "^(.)().-(.)()$",
        },

        -- Custom surrounds for programming
        ["f"] = {
          add = function()
            local result = require("nvim-surround.config").get_input("Enter the function name: ")
            if result then
              return { { result .. "(" }, { ")" } }
            end
          end,
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "a(" })
          end,
          delete = "^(.-%()().-(%))()$",
          change = {
            target = "^(.-%()().-(%))()$",
            replacement = function()
              local result = require("nvim-surround.config").get_input("Enter the function name: ")
              if result then
                return { { result .. "(" }, { ")" } }
              end
            end,
          },
        },

        -- HTML/XML tags
        ["t"] = {
          add = function()
            local result = require("nvim-surround.config").get_input("Enter the HTML tag: ")
            if result then
              return { { "<" .. result .. ">" }, { "</" .. result:match("^%S*") .. ">" } }
            end
          end,
          find = function()
            return require("nvim-surround.config").get_selection({ motion = "at" })
          end,
          delete = "^(<%w->).-(</<%w->)()$",
          change = {
            target = "^<(%w-)().-(</%w->)()$",
            replacement = function()
              local result = require("nvim-surround.config").get_input("Enter the HTML tag: ")
              if result then
                return { { "<" .. result .. ">" }, { "</" .. result:match("^%S*") .. ">" } }
              end
            end,
          },
        },

        -- Go/Java specific surrounds
        ["g"] = {
          add = function()
            -- Prompt for Go construct type
            local constructs = {
              ["i"] = { "if ", " {", "}" },
              ["f"] = { "for ", " {", "}" },
              ["w"] = { "switch ", " {", "}" },
              ["s"] = { "select {", "}" },
            }
            local choice = require("nvim-surround.config").get_input("Go construct (i/f/w/s): ")
            if choice and constructs[choice] then
              return { constructs[choice][1] .. constructs[choice][2], constructs[choice][3] }
            end
          end,
        },

        -- JSON/YAML quotes
        ["j"] = {
          add = { '"', '"' },
          find = function()
            return require("nvim-surround.config").get_selection({ motion = 'a"' })
          end,
          delete = "^(.)().-(.)()$",
        },
      },

      -- Aliases for common operations
      aliases = {
        ["a"] = ">", -- Angle brackets
        ["b"] = ")", -- Brackets
        ["B"] = "}", -- Braces
        ["r"] = "]", -- Square brackets
        ["q"] = { '"', "'", "`" }, -- Any quote
      },

      -- Highlight configuration
      highlight = {
        duration = 2000,
      },

      -- Move cursor to end of surround in insert mode
      move_cursor = "begin",

      -- Indent when adding line surrounds
      indent_lines = function(start, stop)
        local b = vim.bo
        -- Only perform auto-indenting if a formatter is set up
        if start < stop and (b.autoindent or b.smartindent or b.cindent) then
          vim.cmd(string.format("silent normal! %dG=%dG", start, stop))
        end
      end,
    })
  end,
}
