local function is_valid_git_blame_output(line)
  -- 正则表达式模式
  local pattern = "^[0-9a-f]+ %(.-%) .+$"
  return string.match(line, pattern) ~= nil
end

local function trim(s)
  return s:match("^%s*(.-)%s*$")
end

local function split(inputstr, sep)
  if sep == nil then
    sep = "%s" -- 默认分隔符为空格
  end
  local t = {} -- 用于存储分割后的结果
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

local function random_number()
  return math.random(100, 500)
end

-- Function to map a number to 1 or 2 using modulo operation
local function map_to_one_or_two(number)
  return (number % 2) + 1
end

-- Generate a random number and map it
local function generate_and_map()
  local number = random_number()
  local mapped_value = map_to_one_or_two(number)
  return number, mapped_value
end

local function parseStringToObject(input)
  local obj = {}
  -- 移除多余的空格
  input = input:gsub("%s+", "")
  for key, value in input:gmatch("(%w+):([^;]+);") do
    obj[key] = value
  end
  return obj
end

local function get_current_user()
  local user = os.getenv("USER") or os.getenv("USERNAME")
  if not user then
    print("Unable to get current user.")
    return nil
  end
  return user
end

local function get_available_nerd_fonts()
  local fonts = {}
  local handle = io.popen("fc-list :family") -- Linux/macOS command
  if handle then
    for line in handle:lines() do
      local font = line:match("^([^:]+):")
      if font and font:match("Nerd") then
        table.insert(fonts, font)
      end
    end
    handle:close()
  end
  return fonts
end

local function get_colorschemes()
  local colors = {}
  for _, colorscheme in ipairs(vim.fn.getcompletion("", "color")) do
    table.insert(colors, colorscheme)
  end

  return colors
end

local M = {
  last_line = -1,
  prev_mark_id = 0,
  prev_buffer_id = 0,
  namespace = vim.api.nvim_create_namespace("blame"),
  socket = nil,
  clientid = "",
  notification_id = nil,
  timer = nil,
  pid = nil,
  port = nil,
}

function M.notify_current_info()
  -- 获取当前正在使用的主题
  -- vim.schedule(function()
  local current_theme = vim.g.colors_name or "default"
  -- print("Current colorscheme:" .. current_theme)
  local current_file = vim.api.nvim_buf_get_name(0)
  -- print("Current file:" .. current_file)
  M.socket:send_text(
    "action:current_info;current_theme:"
      .. current_theme
      .. ";current_file:"
      .. current_file
      .. ";current_pid:"
      .. M.get_pid()
  )
  -- end)
end

function M.start_websocket(id, millsec)
  -- local uv = vim.loop
  local Websocket = require("websocket").Websocket
  -- local Opcodes = require("websocket.types.opcodes")
  -- local print_bases = require("websocket.util.print_bases")
  -- uv.sleep(millsec)
  -- print("thread " .. id .. " =>", uv.thread_self())

  -- local asy = require("plenary.async")

  local sock = Websocket:new({
    host = "127.0.0.1",
    port = 9999,
    path = "/",
    protocols = { "test" },
    origin = "http://localhost",
    auto_connect = true,
  })

  sock:add_on_connect(vim.schedule_wrap(function()
    local user = get_current_user()
    vim.notify("用户(" .. user .. ")连接成功", vim.log.levels.INFO, {
      title = "Websocket",
      icon = "😁",
      timeout = 3000,
    })
    M.notify_current_info()
  end))

  -- sock:add_on_connect()

  sock:add_on_message(vim.schedule_wrap(function(frame)
    -- local status, data = pcall(vim.json.decode, frame.payload)
    -- print(status)
    -- print("data" .. data)

    local maps = parseStringToObject(frame.payload)
    if maps.action == "random_scheme" then
      if M.timer == nil then
        local operate_pid = maps.payload
        local tps, title, random_int, colorscheme = M.random()
        M.start_timer_random(title, random_int, colorscheme)
        M.set_that(tps, colorscheme)
        if tostring(operate_pid) == tostring(M.get_pid()) then
        end
      end
    elseif maps.action == "get_current_info" then
      M.aotify_current_info()
      -- M.notify_current_info()
    elseif maps.action == "deploy_success" then
      -- vim.notify("Set GO!\npid:" .. maps.payload .. "\nport: " .. maps.port, vim.log.levels.INFO, {
      --   title = "代码编译",
      --   icon = "😁",
      --   timeout = 3000,
      -- })
      M.pid = tonumber(maps.payload)
      M.port = tonumber(maps.port)

      require("lualine").setup({
        sections = { lualine_c = { "filename", M.get_service_info } },
      })
      -- M.attach_pid()
    elseif maps.action == "ack" then
      M.clientid = maps.payload
    else
      -- print(maps.action)
    end
  end))

  sock:connect()

  return sock
end

function M.cowboy()
  --- @type table?
  local id
  local ok = true
  for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
    local count = 0
    local timer = assert(vim.loop.new_timer())
    local map = key
    vim.keymap.set("n", key, function()
      if vim.v.count > 0 then
        count = 0
      end
      if count >= 20 then
        ok, id = pcall(vim.notify, "休息一会好吗", vim.log.levels.WARN, {
          icon = "😁",
          replace = id,
          keep = function()
            return count >= 20
          end,
        })
        if not ok then
          id = nil
          return map
        end
      else
        count = count + 1
        timer:start(500, 0, function()
          count = 0
        end)
        return map
      end
    end, { expr = true, silent = true })
  end
end

function M.insert_go_err()
  -- 获取当前光标位置
  local save_cursor = vim.api.nvim_win_get_cursor(0)
  -- 获取当前行的文本
  local line = vim.api.nvim_get_current_line()
  -- 使用正则表达式匹配缩进
  local indent = string.match(line, "^%s*")
  -- 构建要插入的文本
  local text = 'util.HasError(err, "", -1)'
  -- 在下一行插入新行
  vim.cmd("normal! o" .. text)
  -- 应用相同的缩进
  vim.cmd("normal! ^" .. indent .. "|")
  -- 还原光标位置
  vim.api.nvim_win_set_cursor(0, save_cursor)
end

function M.websocket()
  M.socket = M.start_websocket(1, 3000)
end

function M.ping()
  M.socket:send_text("ping")
end

function M.start_timer_random(title, seconds, cls)
  local async = require("plenary.async")
  local await = async.util.sleep
  local uv = vim.loop
  local end_time = os.time() + seconds
  local notify = vim.notify
  local timer = assert(uv.new_timer()) --) 创建一个变量来存储通知对象
  -- local notification_id
  local ok = true
  local notification_id
  local refresh
  local refresh_tps
  local refresh_result
  local loading_timer = 0

  -- 定义一个更新函数
  local function update_timer()
    -- refresh = false
    local remaining = 0
    local remain_text = ""
    if loading_timer > 0 and loading_timer < 4 then
      remain_text = string.rep(".", loading_timer)
      loading_timer = loading_timer + 1
    else
      remaining = end_time - os.time()
      if remaining < 0 then
        if loading_timer > 3 then
          loading_timer = 0
        else
          loading_timer = 1
          return
        end

        -- 重新刷新主题
        local tps, random_title, random_int, random_result = M.random()
        title = random_title
        end_time = os.time() + random_int
        remaining = end_time - os.time()
        cls = random_result
        refresh = true
        refresh_tps = tps
        refresh_result = random_result
      end
      remain_text = remaining .. "s"
    end
    if remaining == 0 and loading_timer == 0 then
      remain_text = "❌"
    end
    -- await(2000)
    local message = "Color Scheme: " .. cls .. "\nTimer Remaing: " .. remain_text
    -- 更新通知内容
    ok, notification_id = pcall(notify, message, vim.log.levels.INFO, {
      title = title,
      icon = "😁",
      replace = notification_id,
      -- keep = function()
      --   return remaining > 0
      -- end,
    })

    M.notification_id = notification_id
    -- if not ok then
    --   notification_id = nil
    -- end
  end
  -- 启动定时器，每秒更新一次
  timer:start(
    0,
    1000,
    vim.schedule_wrap(function()
      async.run(update_timer, function()
        if refresh then
          async.run(function()
            M.set_that(refresh_tps, refresh_result)
          end, function() end)
          refresh = false
        end
      end)
    end)
  )
  M.timer = timer
end

-- Function to set a random Nerd font
function M.random_nerd_font()
  local fonts = get_available_nerd_fonts()
  if #fonts == 0 then
    print("No Nerd fonts found.")
    return
  end
  local font = fonts[math.random(#fonts)] .. ":h12" -- Adjust font size as needed
  -- vim.cmd("set guifont=" .. font)
  -- print("Font changed to: " .. font)
  -- 生成随机数
  local random_int = math.random(100, 500)
  return "随机字体", random_int, font
end

function M.random_colorscheme()
  local scheme = get_colorschemes()
  if #scheme == 0 then
    print("No colors specified")
    return
  end
  local r_index = math.random(1, #scheme)
  local random_colorscheme = scheme[r_index]
  -- vim.cmd("colorscheme " .. random_colorscheme)
  -- print("colorscheme set to " .. random_colorscheme)
  -- 生成随机数
  local random_int = math.random(1, 300)
  return "随机主题", random_int, random_colorscheme
end

function M.random()
  math.randomseed(os.time())
  local _, mapped_value = generate_and_map()
  local title, random_int, cls
  if mapped_value == 1 then
    title, random_int, cls = M.random_colorscheme()
  else
    title, random_int, cls = M.random_colorscheme()
  end

  return 1, title, random_int, cls
end

function M.set_that(mapped_val, ts)
  if mapped_val == 1 then
    M.set_theme(ts)
  else
    M.set_font(ts)
  end
  -- M.notify_current_info()
end

function M.set_theme(color_scheme)
  vim.cmd("set background=dark")
  vim.cmd("colorscheme " .. color_scheme)
  -- M.notify_current_info()
end

function M.set_font(font)
  vim.cmd("set guifont=" .. font)
  -- M.notify_current_info()
end
function M.stop_random_scheme()
  if M.timer ~= nil then
    M.notification_id = nil
    M.timer:stop()
    M.timer:close()
    M.timer = nil
  end
end

function M.get_pid()
  local uv = vim.loop
  return uv.os_getpid()
end

function M.seq_number()
  local inp = vim.fn.input("请输入表达式: ")
  print(inp)
  local range, format = inp:match("(%d+-%d+),(.+)")
  print(range)
  print(format)
  -- 检查解析是否成功
  if not range or not format then
    print("Invalid input format")
    return
  end
  local start_num, end_num = range:match("(%d+)-(%d+)")
  start_num = tonumber(start_num)
  end_num = tonumber(end_num)

  -- 检查起始和结束数字是否有效
  if not start_num or not end_num or start_num > end_num then
    print("Invalid range")
    return
  end
  -- 计算格式字符串中的 %d 占位符数量
  local placeholders = {}
  for _ in format:gmatch("%%d") do
    table.insert(placeholders, "%d")
  end

  -- 获取当前行号
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = {}

  -- 生成代码行
  for i = start_num, end_num do
    local values = {}
    unpack = unpack or table.unpack

    for _ = 1, #placeholders do
      table.insert(values, i)
    end
    print(values)
    table.insert(lines, format:format(unpack(values)))
  end

  vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, lines)
end

function M.functions()
  vim.ui.select({ "1:SEQ_NUMBER(eg.1-10,test%d)" }, {
    prompt = "想做什么?",
    telescope = require("telescope.themes").get_cursor(),
  }, function(selected)
    if string.find(selected, "1") then
      M.seq_number()
    end
  end)

  -- local pickers = require("telescope.pickers")
  -- local finders = require("telescope.finders")
  -- local conf = require("telescope.config").values
  -- local colors = function(opts)
  --   opts = opts or {}
  --   pickers
  --     .new(opts, {
  --       prompt_title = "colors",
  --       finder = finders.new_table({
  --         results = { "red", "green", "blue" },
  --       }),
  --       sorter = conf.generic_sorter(opts),
  --     })
  --     :find()
  -- end
  -- colors()
end

function M.StartImplMethod()
  local struct_name = M.is_cursor_on_struct()
  if struct_name ~= nil then
    -- local choices = { "Create Method1", "Create Method2", "Create Method3" }
    vim.ui.select({ "1.controller", "2. service", "3. model" }, {
      prompt = "定义方法",
      telescope = require("telescope.themes").get_cursor(),
    }, function(selected)
      if string.find(selected, "1") then
        local input_method = vim.fn.input("")
        if input_method ~= "" then
          local split_me = split(input_method, " ")
          -- 打印结果
          for i, v in ipairs(split_me) do
            M.create_method_for_controller(struct_name, v)
          end
        end
      elseif string.find(selected, 3) then
        local input_method = vim.fn.input("")
        if input_method ~= "" then
          local split_me = split(input_method, " ")
          -- 打印结果
          for i, v in ipairs(split_me) do
            M.create_method_for_model(struct_name, v)
          end
        end
      end
    end)
    -- local input_method = vim.fn.input(struct_name .. "实现方法:")
    -- M.create_method_for_struct(struct_name, input_method)
  end
end

function M.create_method_for_controller(struct_name, method_name)
  local lines = {
    "",
    "func ("
      .. string.sub(struct_name, 1, 1):lower()
      .. " *"
      .. struct_name
      .. ") "
      .. method_name
      .. "(ctx *gin.Context) {",
    "    // TODO: implement",
    "    // Step1: -- 接受参数 --",
    "    param := map[string]interface{}{}",

    "    err := ctx.ShouldBindJSON(&param) ",

    '    util.HasError(err, "", -1) ',

    "    // Step2: -- 业务逻辑 --",

    "    // Step3: -- 响应返回 --",
    "}",
  }

  vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
  vim.api.nvim_command("normal! G")
end

function M.create_method_for_model(struct_name, method_name)
  local lines = {
    "",
    "func ("
      .. string.sub(struct_name, 1, 1):lower()
      .. " *"
      .. struct_name
      .. ") "
      .. method_name
      .. "(db *gorm.DB) error {",
    "    // TODO: implement",
    "    return nil",
    "}",
  }

  vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
  vim.api.nvim_command("normal! G")
end

function M.is_cursor_on_struct()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if not node then
    return nil
  end

  while node do
    local node_type = node:type()
    -- print(node_type)

    if node_type == "type_spec" then
      local type_node = node:field("type")[1]
      if type_node and type_node:type() == "struct_type" then
        local name_node = node:field("name")[1]
        -- print(name_node)
        if name_node then
          local node_text = vim.treesitter.get_node_text(name_node, 0)
          return node_text
        end
      end
      -- print(type_node)
    end
    node = node:parent()
  end
  return nil
end

function M.attach_pid()
  local dap = require("dap")
  local async = require("plenary.async")
  local session = dap.session()
  local await = async.util.sleep
  dap.disconnect()
  dap.close()
  -- await(2000)
  dap.run({
    type = "go",
    request = "attach",
    processId = M.pid,
    name = "attach_go_debugger",
  })
end

function M.get_service_info()
  return "Watching: 🐷: " .. M.pid .. " 🐽: " .. M.port
end

function M.get_swag_comments()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1

  --- 获取解析树
  local parser = vim.treesitter.get_parser(bufnr, "go")
  local tree = parser:parse()[1]
  local root = tree:root()

  local function find_method_node(node, row)
    if not node then
      return nil
    end
    for child in node:iter_children() do
      if child:type() == "function_declaration" or child:type() == "method_declaration" then
        local start_row, _, end_row, _ = child:range()
        if start_row <= row and end_row >= row then
          return child
        end
      end
      local found = find_method_node(child, row)
      if found then
        return found
      end
    end
    return nil
  end

  local method_node = find_method_node(root, cursor_row)
  if not method_node then
    print("No method found")
    return
  end

  -- 查找方法上方的注释节点
  local comments = {}
  local start_row = method_node:start()
  local comment_query = vim.treesitter.query.parse(
    "go",
    [[
      (comment) @comment
    ]]
  ) -- 替换 'your_language' 为具体语言
  for _, node, _ in comment_query:iter_captures(root, bufnr, 0, start_row) do
    local comment_row = node:start()
    if comment_row < start_row then
      table.insert(comments, vim.treesitter.get_node_text(node, bufnr))
    end
  end

  -- 输出 Swag 注释
  for _, comment in ipairs(comments) do
    if
      comment:match("@Summary")
      or comment:match("@Description")
      or comment:match("@Tags")
      or comment:match("@Accept")
      or comment:match("@Produce")
      or comment:match("@Param")
      or comment:match("@Success")
      or comment:match("@Failure")
      or comment:match("@Router")
    then
      print(comment)

      -- 如果是 @Router 注释，解析路由信息
      if comment:match("@Router") then
        local route_info = comment:match("@Router%s+(.-)%s*$")
        if route_info then
          local path, method = route_info:match("([^%s]+)%s+%[(%a+)%]")
          print("Path: " .. (path or "N/A"))
          print("Method: " .. (method or "N/A"))
        end
      end
    end
  end
end

function M.toggle_blame()
  -- print("CursorMoved")
  vim.api.nvim_buf_clear_namespace(0, M.namespace, 0, -1)
  local file = vim.fn.expand("%")
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local cmd = string.format("git blame -L %d,%d -- %s", line, line, file)
  -- vim.cmd("silent! lua require('gaomengnan.discipline').update_cursor()")
  local output = vim.fn.system(cmd)
  -- if is_valid_git_blame_output(line) == false then
  --   return
  -- end
  -- 检查每一行是否符合 git blame 格式
  -- vim.api.nvim_buf_set_virtual_text(0, namespace, line - 1, { { trim(output), "Comment" } }, {})

  --   vim.api.nvim_buf_clear_namespace(0, namespace, last_line - 1, last_line)
  -- end
  --
  -- local current_line = vim.fn.line(".")
  -- print(current_line)
  local options = {
    virt_text = { { trim(output), "Comment" } },
  }
  local buffer_id = 0
  local markid = vim.api.nvim_buf_set_extmark(buffer_id, M.namespace, line - 1, 0, options)

  -- vim.api.nvim_buf_del_extmark(M.prev_buffer_id, M.namespace, M.prev_mark_id)

  M.prev_mark_id = markid
  M.prev_buffer_id = buffer_id
  -- last_line = current_line
end

-- function M.cmp1()
--   local ok, cmp = pcall(require, "cmp")
--   if not ok then
--     return
--   end
--   local source = {}
--
--   source.new = function()
--     return setmetatable({}, { __index = source })
--   end
--
--   source.get_trigger_characters = function()
--     return { "#" }
--   end
--
--   source.complete = function(self, request, callback)
--     local input = request.context.cursor_before_line:match("#(%w+)%.(%w*)")
--     local items = {}
--     if input then
--       local tag, className = input:match("^(%w+)%.(%w*)")
--       if tag and className then
--         local label = string.format('<%s class="%s"></%s>', tag, className, tag)
--         table.insert(items, { label = label, insertText = label })
--       end
--     end
--     callback({ items = items, isIncomplete = false })
--   end
-- end

local Job = require("plenary.job")
function M.get_media()
  Job:new({
    command = "nowplaying-cli",
    args = { "get", "title", "artist" },
    on_exit = function(j, return_val)
      if return_val == 0 then
        local filtered_data = {}

        -- 遍历原始数据表，过滤掉 "null" 和 "NUll"
        for _, value in ipairs(j:result()) do
          if value ~= "null" and value ~= "NUll" then
            table.insert(filtered_data, value)
          end
        end

        local length = #filtered_data

        if length == 0 then
          vim.g.now_playing = ""
          return
        end

        local result = table.concat(filtered_data, " 💘 ")
        vim.g.now_playing = "Song: " .. result
      else
        vim.g.now_playing = ""
        -- print("Failed to get now playing info")
      end
    end,
  }):start()
end

M.timer_media = function()
  local interval = 10000 -- 10 seconds in milliseconds
  vim.fn.timer_start(interval, function()
    M.get_media()
  end, { ["repeat"] = -1 })
end

M.ui = function()
  local n = require("nui-components")

  local renderer = n.create_renderer({
    width = 60,
    height = 8,
  })

  local signal = n.create_signal({
    is_loading = false,
    text = "lanugh config",
  })

  local body = function()
    return n.form(
      {
        id = "form",
        submit_key = "<CR>",
        on_submit = function(is_valid)
          print(is_valid)
        end,
      },
      n.text_input({
        autofocus = true,
        autoresize = true,
        size = 1,
        border_label = "Name",
        max_lines = 5,
        validate = n.validator.min_length(3),
      }),
      n.text_input({
        autofocus = false,
        autoresize = true,
        size = 1,
        border_label = "Working directory",
        max_lines = 5,
        validate = n.validator.min_length(3),
      }),
      n.text_input({
        autofocus = false,
        autoresize = true,
        size = 1,
        border_label = "Run envariables",
        max_lines = 5,
        validate = n.validator.min_length(3),
      }),

      n.text_input({
        autofocus = false,
        autoresize = true,
        size = 1,
        border_label = "Program arguments",
        max_lines = 5,
        validate = n.validator.min_length(3),
      })
    )
    -- return n.rows(
    --   n.columns(
    --     { flex = 0 },
    --     n.text({
    --
    --     }),
    --     n.text_input({
    --       id = "text-input",
    --       autofocus = true,
    --       flex = 1,
    --       max_lines = 1,
    --     }),
    --     -- n.gap(1),
    --     -- n.button({
    --     --   label = "Send",
    --     --   padding = {
    --     --     top = 1,
    --     --   },
    --     --   on_press = function()
    --     --     signal.is_loading = true
    --     --
    --     --     vim.defer_fn(function()
    --     --       local ref = renderer:get_component_by_id("text-input")
    --     --       signal.is_loading = false
    --     --       signal.text = ref:get_current_value()
    --     --     end, 2000)
    --     --   end,
    --     -- }),
    --     n.spinner({
    --       is_loading = signal.is_loading,
    --       padding = { top = 1, left = 1 },
    --       hidden = signal.is_loading:negate(),
    --     })
    --   ),
    --   n.paragraph({
    --     lines = signal.text,
    --     align = "center",
    --     is_focusable = false,
    --   })
    -- )
  end

  renderer:render(body)
end
return M
