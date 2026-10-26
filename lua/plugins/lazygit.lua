return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    git_command = "~/AppData/Local/Microsoft/WinGet/Packages/JesseDuffield.lazygit_Microsoft.Winget.Source_8wekyb3d8bbwe/lazygit",
  },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit(TUI)" },
  },
}
