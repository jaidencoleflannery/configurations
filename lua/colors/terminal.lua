local terminal = {
  bg               = "#000000",
  panel            = "#403d39",
  text             = "#e5e7eb",
  muted            = "#ccc5b9",
  accent           = "#ffd60a",
  danger           = "#e63946",
  ok               = "#ecf39e",
  warn             = "#fca311",
}

local M = {}

function M.setup()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "terminal"

  local groups = {
    -- Base UI
    Normal       = { fg = terminal.text, bg = terminal.bg },
    NormalFloat  = { fg = terminal.text, bg = terminal.panel },
    FloatBorder  = { fg = terminal.accent, bg = terminal.panel },
    ColorColumn  = { bg = terminal.panel },
    Cursor       = { fg = terminal.accent, bg = terminal.accent },
    CursorLine   = { bg = terminal.panel },
    LineNr       = { fg = terminal.muted },
    CursorLineNr = { fg = terminal.accent, bold = true },
    VertSplit    = { fg = terminal.panel, bg = terminal.bg },
    StatusLine   = { fg = terminal.text, bg = terminal.panel },
    StatusLineNC = { fg = terminal.muted, bg = terminal.panel },
    Pmenu        = { fg = terminal.accent, bg = terminal.panel },
    Visual       = { fg = terminal.accent, bg = terminal.panel },
    Search       = { fg = terminal.accent, bg = terminal.panel },
    IncSearch    = { fg = terminal.bg, bg = terminal.accent },
    NonText      = { fg = terminal.muted },

    -- Syntax
    Comment      = { fg = terminal.muted, italic = true },
    Constant     = { fg = terminal.accent },
    String       = { fg = terminal.ok },
    Character    = { fg = terminal.ok },
    Number       = { fg = terminal.accent },
    Boolean      = { fg = terminal.accent },
    Float        = { fg = terminal.accent },
    Identifier   = { fg = terminal.text },
    Function     = { fg = terminal.accent, bold = true },
    Statement    = { fg = terminal.accent },
    Conditional  = { fg = terminal.accent },
    Repeat       = { fg = terminal.accent },
    Label        = { fg = terminal.accent },
    Operator     = { fg = terminal.accent },
    Keyword      = { fg = terminal.accent },
    Exception    = { fg = terminal.danger },
    PreProc      = { fg = terminal.warn },
    Type         = { fg = terminal.accent },
    Special      = { fg = terminal.warn },
    Underlined   = { underline = true },
    Error        = { fg = terminal.danger, bold = true },
    Todo         = { fg = terminal.warn, bold = true },

    -- Diagnostics
    DiagnosticError = { fg = terminal.danger },
    DiagnosticWarn  = { fg = terminal.warn },
    DiagnosticInfo  = { fg = terminal.accent },
    DiagnosticHint  = { fg = terminal.muted },

    -- Diff
    DiffAdd     = { fg = terminal.ok, bg = terminal.panel },
    DiffChange  = { fg = terminal.warn, bg = terminal.panel },
    DiffDelete  = { fg = terminal.danger, bg = terminal.panel },
    DiffText    = { fg = terminal.accent, bg = terminal.panel },
  }

  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

return M
