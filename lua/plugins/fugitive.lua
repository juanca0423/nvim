return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git" },
  keys = {
    -- Fetch y Pull
    { "<leader>gf", "<cmd>Git fetch --all -p<cr>", desc = "Git fetch all" },
    { "<leader>gl", "<cmd>Git pull<cr>", desc = "Git pull" },

    -- Status y Commit
    { "<leader>gs", "<cmd>Git<cr>", desc = "Git status (Fugitive)" },
    { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },

    -- Push y Branching
    { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
    { "<leader>gb", "<cmd>Git branch<cr>", desc = "Git branch" },

    -- Diff y Blame
    { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff split" },
    { "<leader>gB", "<cmd>Git blame<cr>", desc = "Git blame" },
    { "<leader>gq", "<cmd>Gvdiffsplit!<cr>", desc = "Git diff 3-way (conflictos)" },
  },
}
