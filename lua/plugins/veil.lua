local enabled = false
if vim.g.vscode then
  enabled = false
end
return {
  "willothy/veil.nvim",
  enabled = enabled,
  lazy = false,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local currentTimestamp = os.time()
    local currentDateTable = os.date("*t", currentTimestamp)
    print(currentDateTable.wday)
    local weekdays = {
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    }
    local currentWeekdayString = weekdays[currentDateTable.wday]
    local builtin = require("veil.builtin")
    require("veil").setup({
      sections = {
        builtin.sections.animated(builtin.headers.frames_days_of_week[currentWeekdayString], {
          hl = { fg = "#FFA500" },
        }),
        builtin.sections.buttons({
          {
            icon = "",
            text = "Find Files",
            shortcut = "f",
            callback = function()
              require("telescope.builtin").find_files()
            end,
          },
          {
            icon = "",
            text = "Find Word",
            shortcut = "g",
            callback = function()
              require("telescope.builtin").live_grep()
            end,
          },
        }),
        -- builtin.sections.oldfiles(),
      },
      mappings = {},
      startup = true,
      listed = false,
    })
  end,
}
