-- local ok, cmp = pcall(require, "cmp")
-- if not ok then
--   return
-- end
local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end
-- source.get_keyword_pattern = function()
--   return [[#\w+\.\w*]]
-- end

source.is_available = function()
  return true
end
source.get_trigger_characters = function()
  return { "#" }
end

source.complete = function(self, request, callback)
  local input = request.context.cursor_before_line
  print(input)
  local items = {}
  if input then
    local tag, className = input:match("#(%w+)%.(%w+)")
    print(tag)
    print(className)
    if tag and className then
      local label = string.format('<%s class="%s"></%s>', tag, className, tag)
      table.insert(items, { label = label, insertText = label })
    end
  end
  callback({ items = items, isIncomplete = false })
end
return source
