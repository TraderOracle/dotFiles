vim.opt.clipboard = "unnamed,unnamedplus"
-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false
-- Make line numbers default
vim.opt.number = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = true
-- Enable break indent
vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- Decrease update time
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true
vim.opt.modelines = 5
vim.opt.number = true
vim.opt.relativenumber = true
-- change line number font
vim.cmd('highlight LineNr ctermfg=240 guifg=#293cba')
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#293cba' })

-- Performance-related settings
vim.opt.lazyredraw = true      -- Don't redraw screen during macros
vim.opt.ttyfast = true         -- Faster terminal connection
vim.opt.swapfile = false       -- Disable swapfile to prevent potential lag

-- Prevent screen blanking with synmaxcol
vim.opt.synmaxcol = 200        -- Only highlight first 200 columns

-- Terminal-specific optimizations
local terminal = os.getenv("TERM")
if terminal and (terminal:match("screen") or terminal:match("tmux")) then
  -- Reduce features in tmux/screen to prevent blanking
  vim.opt.lazyredraw = true
  vim.opt.showcmd = false      -- Don't show command in bottom right
  vim.opt.ruler = false        -- Don't show ruler
end
--
-- Add filetype detection for Pine Script
vim.filetype.add({
  extension = {
    pine = "pinescript",
  },
})
-- ========================== BASIC KEYMAPS ============================
-- =====================================================================

--vim.keymap.set("n", "<leader>d", ":Neotree position=current ~/Documents<CR>")

vim.keymap.set('n', 'w', 'b')
vim.keymap.set('n', 'c', 'caw')
vim.keymap.set('n', 'e', 'w')
vim.keymap.set('n', 'v', 'V', { noremap = true })
vim.keymap.set('n', 'V', 'v', { noremap = true })

-- Search and replace shortcut
vim.keymap.set('n', '<leader>r', ':%s/', { desc = "Replace Text, whole file" })
vim.keymap.set('n', '<leader>R', '<cmd>GrugFar<CR>', { desc = "GrugFar SearchReplace" })
vim.keymap.set('n', '<leader>t', '<cmd>BufferLineCycleNext<CR>', { desc = "NextBuffer" })
vim.keymap.set('n', '<leader>u', ':lua MiniSessions.select()<CR>', { desc = "Load Sessions" })
vim.keymap.set('n', '<leader>t', '<cmd>BufferLineCycleNext<CR>', { desc = "NextBuffer" })
vim.keymap.set('n', '<leader>w', '<cmd>MiniSessions.write("Config Files")<CR>', { desc = "Save Session" })
vim.keymap.set('n', '<Leader>i', ':Dashboard<CR>', { desc = "Dashboard", noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- ====================== VISUAL MODE OPTIMIZATIONS =====================
-- =====================================================================

-- Fix for visual mode screen blanking issues
vim.api.nvim_create_autocmd({"ModeChanged"}, {
  pattern = {"*"},
  callback = function()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "v" or mode == "V" or mode == "\22" then  -- Visual mode
      -- Apply special settings for visual mode to prevent blanking
      vim.opt.cursorline = false   -- Disable cursorline in visual mode
      vim.opt.lazyredraw = true    -- Force lazyredraw in visual mode
      vim.opt.regexpengine = 1     -- Use old regexp engine which is more stable
      
      -- Disable syntax highlighting temporarily if needed for large selections
      local line_count = vim.fn.line("'>") - vim.fn.line("'<")
      if line_count > 100 then
        vim.cmd("syntax clear")
      end
    else
      -- Restore normal settings
      vim.opt.cursorline = true
      vim.opt.regexpengine = 0    -- Default regexp engine
      vim.cmd("syntax on")
    end
  end
})

-- Optimize visual mode highlight colors to use simpler rendering
vim.cmd([[
  hi Visual guibg=#3a3a3a guifg=NONE gui=NONE cterm=NONE
  hi VisualNOS guibg=#3a3a3a guifg=NONE gui=NONE cterm=NONE
]])

-- ======================== BASIC AUTOCOMMANDS =========================
-- =====================================================================

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

-- Save and load folds when closing/opening files
vim.api.nvim_create_autocmd({"BufWinLeave"}, {
  pattern = {"*.*"},
  desc = "save view (folds), when closing file",
  command = "mkview",
})

vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {"*.*"},
  desc = "load view (folds), when opening file",
  command = "silent! loadview"
})

-- Track project directories for dashboard
vim.api.nvim_create_autocmd({"DirChanged"}, {
  callback = function()
    local current_dir = vim.fn.getcwd()
    -- Skip temporary or system directories
    if string.match(current_dir, "^/tmp") or string.match(current_dir, "^/var") then
      return
    end
    
    -- Path to dashboard projects file
    local projects_file = vim.fn.expand("~/.local/share/nvim/dashboard_projects")
    
    -- Read existing projects
    local projects = {}
    local file = io.open(projects_file, "r")
    if file then
      for line in file:lines() do
        if line ~= current_dir then -- Avoid duplicates
          table.insert(projects, line)
        end
      end
      file:close()
    end
    
    -- Add current directory at the beginning
    table.insert(projects, 1, current_dir)
    
    -- Keep only a limited number of projects
    while #projects > 15 do
      table.remove(projects)
    end
    
    -- Write projects back to file
    file = io.open(projects_file, "w")
    if file then
      for _, project in ipairs(projects) do
        file:write(project .. "\n")
      end
      file:close()
    end
  end
})

-- ======================= LAZY.NVIM SETUP =============================
-- =====================================================================

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})


require('mini.comment').setup()
require('mini.sessions').setup{
  autoread = true,
  autowrite = true,
  verbose = { read = false, write = true, delete = true },
}
require('mini.pick').setup()
require('mini.git').setup()
require('mini.ai').setup()
require('lualine').setup ()
require('incline').setup()

vim.opt.termguicolors = true
require("bufferline").setup{}

require('nightfox').setup({
  options = {
    styles = {
      keyword = "grey.dim",
      comments = "italic",
      keywords = "bold",
      types = "italic,bold",
    }
  }
})

require('render-markdown').setup({ latex = { enabled = false } })

vim.cmd("colorscheme carbonfox")

-- ========================  AUTO FORMATTING ===========================
-- =====================================================================

vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>")

-- open file_browser with the path of the current buffer
vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

-- Alternatively, using lua API
vim.keymap.set("n", "<space>fb", function()
	require("telescope").extensions.file_browser.file_browser()
end)

local gen_spec = require('mini.ai').gen_spec
require('mini.ai').setup({
  custom_textobjects = {
     -- Tweak argument to be recognized only inside `()` between `;`
    a = gen_spec.argument({ brackets = { '%b()' }, separator = ';' }),

     -- Tweak function call to not detect dot in function name
    f = gen_spec.function_call({ name_pattern = '[%w_]' }),

    -- Function definition (needs treesitter queries with these captures)
    F = gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),

    -- Make `|` select both edges in non-balanced way
     ['|'] = gen_spec.pair('|', '|', { type = 'non-balanced' }),
  }
})

-- =====================================================================
-- ========================   MISCELLANEOUS  ===========================
-- =====================================================================

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    -- your other languages
    "pine", -- Add this for Pine Script
  },
  -- rest of your config
})

local dashboard = require('dashboard')

-- Function to get formatted date and time
local function get_date_time()
  local date = os.date("%A, %d %B %Y")
  local time = os.date("%H:%M:%S")
  return {
    " " .. date,
    " " .. time,
    " ",
  }
end

dashboard.setup {
  theme = 'hyper',
  config = {
     project = {
      enable = true,
      limit = 13,
      icon = '🗂️ ',
      label = 'Projects',
      -- Manually specify projects
      paths = {
        "~/Documents/CodeJS",
        "~/Documents/Code",
      },
      action = function(path)
        vim.cmd('Neotree position=current' .. path)
      end
    }, 
    header = get_date_time(),
         disable_session = false,
          shortcut = {
           {
              icon = '🦋 ',
              icon_hl = '@variable',
              desc = 'Files',
              group = 'Label',
              action = 'Telescope find_files',
              key = 'f',
            },
            {
              desc = '🐹 MotiveWave',
              group = 'DiagnosticHint',
              action = 'Telescope file_browser path=~/Documents/Github/MotiveWave',
              key = 'm',
            },
            {
              desc = '🐹 VIM Files',
              group = 'DiagnosticHint',
              action = 'Telescope file_browser path=~/.config/nvim',
              key = 'v',
            },
            {
              desc = '🧸 Pine',
              group = 'DiagnosticHint',
              action = 'Telescope file_browser path=~/Documents/Github/TradingView',
              key = 't',
            },
            {
              desc = '🧸 Tradovate',
              group = 'DiagnosticHint',
              action = 'Telescope file_browser path=~/Documents/Github/Tradovate',
              key = 'r',
            },
            {
              desc = '🧸 Ninja',
              group = 'DiagnosticHint',
              action = 'Telescope file_browser path=~/Documents/Github/NinjaTrader',
              key = 'n',
            },
            {
              desc = '✈️ Recent',
              group = 'Number',
              action = 'Telescope oldfiles',
              key = 'r',
            },
            -- action can be a function type
            -- { desc = string, group = 'highlight group', key = 'shortcut key', action = 'action when you press key' },
          }
  }
}

vim.api.nvim_create_autocmd({"BufWinLeave"}, {
  pattern = {"*.*"},
  desc = "save view (folds), when closing file",
  command = "mkview",
})

vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {"*.*"},
  desc = "load view (folds), when opening file",
  command = "silent! loadview"
})


 -- =====================================================================
-- ======================== JAVA/ANT BUILD SYSTEM =======================
-- =====================================================================

-- Helper function to find build.xml in parent directories
local function find_ant_buildfile()
  local current_dir = vim.fn.expand('%:p:h')
  local build_file = current_dir .. '/build.xml'
  
  -- Check if build.xml exists in current directory
  if vim.fn.filereadable(build_file) == 1 then
    return build_file
  end
  
  -- Search up to 5 parent directories
  for i = 1, 5 do
    local parent_dir = vim.fn.fnamemodify(current_dir, ':h')
    if parent_dir == current_dir then break end -- Reached root directory
    
    current_dir = parent_dir
    build_file = current_dir .. '/build.xml'
    
    if vim.fn.filereadable(build_file) == 1 then
      return build_file
    end
  end
  
  return "~/Documents/Github/MotiveWave/MotiveWaveJava/build/build.xml"

end

-- Parse build.xml to extract available targets
local function get_ant_targets(build_file)
  if not build_file or vim.fn.filereadable(build_file) ~= 1 then
    return {}
  end
  
  local content = vim.fn.readfile(build_file)
  local targets = {}
  
  for _, line in ipairs(content) do
    local target_name = string.match(line, '<target%s+name="([^"]+)"')
    if target_name then
      table.insert(targets, target_name)
    end
  end
  
  return targets
end


-- Run Ant with the specified target
local function run_ant(target, build_file)
  build_file = build_file or find_ant_buildfile()
  
  if not build_file then
    vim.notify("No build.xml found in current or parent directories", vim.log.levels.ERROR)
    return
  end
  
  -- Check for ant executable in common locations or use manually set path
  local ant_cmd = vim.g.ant_path or "ant"
  
  -- If no custom path set, search in common locations
  if not vim.g.ant_path then
    local possible_locations = {
      "ant",                                      -- System PATH
      vim.fn.expand("$HOME/apache-ant/bin/ant"),  -- User home directory
      "/usr/local/bin/ant",                       -- Common Unix location
      "/opt/homebrew/bin/ant",                    -- Homebrew on macOS
      "/usr/share/ant/bin/ant",                   -- Some Linux distributions
      "C:\\Program Files\\apache-ant\\bin\\ant.bat", -- Windows
      "C:\\ant\\bin\\ant.bat"                     -- Windows alternative
    }
    
    -- Find the first available ant executable
    for _, loc in ipairs(possible_locations) do
      -- For UNIX-like systems
      if vim.fn.executable(loc) == 1 then
        ant_cmd = loc
        break
      end
      -- For Windows, special handling needed for .bat files
      if vim.fn.has("win32") == 1 and vim.fn.filereadable(loc) == 1 then
        ant_cmd = '"' .. loc .. '"'  -- Quote the path for Windows
        break
      end
    end
  elseif vim.fn.has("win32") == 1 then
    -- Ensure Windows paths are quoted
    ant_cmd = '"' .. vim.g.ant_path .. '"'
  end
  
  -- Construct the command with proper directory change
  local change_dir_cmd = vim.fn.has("win32") == 1 and "cd /d" or "cd"
  local project_dir = vim.fn.fnamemodify(build_file, ':h')
  
  -- Set JAVA_HOME if it exists in the environment
  local java_home = os.getenv("JAVA_HOME") or ""
  local java_home_prefix = ""
  
  if java_home ~= "" then
    if vim.fn.has("win32") == 1 then
      java_home_prefix = 'set "JAVA_HOME=' .. java_home .. '" && '
    else
      java_home_prefix = 'JAVA_HOME="' .. java_home .. '" '
    end
  end
  
  -- Full command with environment setup
  local cmd = string.format('%s %s && %s%s %s', 
                           change_dir_cmd, 
                           project_dir,
                           java_home_prefix,
                           ant_cmd, 
                           target or '')
  
  -- Show command that will be executed (helpful for debugging)
  vim.notify("Running: " .. cmd, vim.log.levels.INFO)
  
  -- Use terminal buffer for better output handling
  vim.cmd('botright 15split')
  vim.cmd('terminal ' .. cmd)
  vim.cmd('startinsert')
end

-- Show a menu to select Ant target
local function select_ant_target()
  local build_file = find_ant_buildfile()
  
  if not build_file then
    vim.notify("No build.xml found in current or parent directories", vim.log.levels.ERROR)
    return
  end
  
  local targets = get_ant_targets(build_file)
  
  if #targets == 0 then
    vim.notify("No targets found in " .. build_file, vim.log.levels.WARN)
    return
  end
  
  -- Add "default" entry at the beginning
  table.insert(targets, 1, "default (no target)")
  
  -- Add quickfix callback to run the selected target
  vim.ui.select(targets, {
    prompt = 'Select Ant target:',
    format_item = function(item)
      return item == "default (no target)" and "default (no target)" or item
    end,
  }, function(choice)
    if not choice then return end
    
    local target = choice == "default (no target)" and "" or choice
    run_ant(target, build_file)
  end)
end

-- Setup keymaps for Ant build
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"java", "xml"},
  callback = function()
    -- <leader>jb - Build Java with Ant (run default target)
    vim.keymap.set("n", "<leader>jb", function()
      run_ant("", find_ant_buildfile())
    end, { buffer = true, desc = "Build Java (Ant default target)" })
    
    -- <leader>jt - Select and run specific Ant target
    vim.keymap.set("n", "<leader>jt", function()
      select_ant_target()
    end, { buffer = true, desc = "Select Ant target" })
    
    -- <leader>jc - Run clean target
    vim.keymap.set("n", "<leader>jc", function()
      run_ant("clean", find_ant_buildfile())
    end, { buffer = true, desc = "Clean Java build (Ant)" })
    
    -- <leader>jr - Run or test the project
    vim.keymap.set("n", "<leader>jr", function()
      -- Try to run "run" target, fallback to "test" if not available
      local build_file = find_ant_buildfile()
      local targets = get_ant_targets(build_file)
      
      if vim.tbl_contains(targets, "run") then
        run_ant("run", build_file)
      elseif vim.tbl_contains(targets, "test") then
        run_ant("test", build_file)
      else
        vim.notify("No run or test target found, running default", vim.log.levels.WARN)
        run_ant("", build_file)
      end
    end, { buffer = true, desc = "Run Java project (Ant)" })
  end
})

-- =====================================================================
-- ======================== JAVA CONFIGURATION ==========================
-- =====================================================================

-- Setup Java compiler and file recognition
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"java"},
  callback = function()
    -- Set compiler to ant for Java files
    vim.opt_local.makeprg = "ant"
    
    -- Set errorformat for ant output
    vim.opt_local.errorformat = 
      [[%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#]]
    
    -- Set path to include common Java directories
    vim.opt_local.path:append("src/**")
    vim.opt_local.path:append("lib/**")
    
    -- Configure Java indentation
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    
    -- Add Java comment string
    vim.opt_local.commentstring = "// %s"
  end
})

-- Configure vim-quickfix for Java
vim.api.nvim_create_autocmd({"QuickFixCmdPost"}, {
  pattern = {"make", "ant"},
  callback = function()
    -- Open quickfix window if there are errors
    if vim.fn.getqflist({size = 0}).size > 0 then
      vim.cmd("cwindow")
    end
  end
})

-- Additional Java keymaps
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"java"},
  callback = function()
    -- Open build.xml in a split
    vim.keymap.set("n", "<leader>jx", function()
      local build_file = find_ant_buildfile()
      if build_file then
        vim.cmd("split " .. build_file)
      else
        vim.notify("No build.xml found", vim.log.levels.ERROR)
      end
    end, { buffer = true, desc = "Open build.xml" })
    
    -- Run ant in makeprg mode to populate quickfix list
    vim.keymap.set("n", "<leader>jm", function()
      vim.cmd("make")
    end, { buffer = true, desc = "Run ant with makeprg" })
    
    -- Compile current Java file directly with javac
    vim.keymap.set("n", "<leader>jj", function()
      local file = vim.fn.expand("%:p")
      local cmd = string.format("javac %s", file)
      
      vim.cmd('botright 10split')
      vim.cmd('terminal ' .. cmd)
      vim.cmd('startinsert')
    end, { buffer = true, desc = "Compile current Java file" })
  end
})
   
   
   
   
