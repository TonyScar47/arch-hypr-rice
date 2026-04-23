-- --- Neovim Configuration (Catppuccin Edition) - arch-hypr-rice ---

-- 1. BOOTSTRAP PLUGIN MANAGER (Lazy.nvim)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. PLUGIN INSTALLATION

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }, -- Advanced syntax highlighting
})

-- 3. THEME CONFIGURATION

vim.cmd.colorscheme "catppuccin-mocha"

-- 4. GLOBAL OPTIONS (From your setup)

local opt = vim.opt

opt.number = true             -- Show line numbers
opt.relativenumber = true     -- Use relative line numbers for faster jumping
opt.mouse = 'a'               -- Enable mouse support in all modes
opt.ignorecase = true         -- Ignore case in search patterns
opt.smartcase = true          -- Override ignorecase if search contains capitals
opt.termguicolors = true      -- Enable 24-bit RGB colors
opt.cursorline = true         -- Highlight the current line
opt.splitright = true         -- Open new vertical splits to the right
opt.splitbelow = true         -- Open new horizontal splits below

-- 5. TABS & INDENTATION

opt.tabstop = 4               -- Number of spaces a tab counts for
opt.shiftwidth = 4            -- Number of spaces for autoindent
opt.expandtab = true          -- Convert tabs to spaces
opt.smartindent = true        -- Make indenting smart

-- 6. CLIPBOARD & BACKUP

opt.clipboard = "unnamedplus" -- Use system clipboard
opt.swapfile = false          -- Disable swap files
opt.backup = false            -- Disable backup files
opt.undofile = true           -- Enable persistent undo history

-- 7. KEYBINDINGS

vim.g.mapleader = " "         -- Set Space as the leader key

-- Fast saving and quitting
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Clear search highlights
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })