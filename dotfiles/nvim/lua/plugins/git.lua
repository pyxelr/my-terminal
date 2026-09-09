-- Multi-file diff review. gitsigns (LazyVim default) covers single-file
-- hunks; diffview adds a file panel + side-by-side view for a whole
-- changeset, which is what gitsigns' `diffthis` can't do.

-- `:MR 87` opens a GitLab merge request's diff without checking it out.
-- Asks glab for the source/target branches, fetches them, then hands
-- diffview the `target...source` range so additions read as additions.
vim.api.nvim_create_user_command("MR", function(opts)
  local id = opts.args
  local raw = vim.fn.system({ "glab", "mr", "view", id, "--output", "json" })
  if vim.v.shell_error ~= 0 then
    return vim.notify("glab failed for MR " .. id .. ":\n" .. raw, vim.log.levels.ERROR)
  end
  local ok, mr = pcall(vim.json.decode, raw)
  if not ok or not mr.source_branch then
    return vim.notify("Could not read branches for MR " .. id, vim.log.levels.ERROR)
  end
  vim.notify(("MR !%s: %s <- %s"):format(id, mr.target_branch, mr.source_branch))
  vim.fn.system({ "git", "fetch", "origin", mr.source_branch, mr.target_branch })
  vim.cmd(("DiffviewOpen origin/%s...origin/%s"):format(mr.target_branch, mr.source_branch))
end, { nargs = 1, desc = "Diffview for a GitLab merge request" })

return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview (working tree)" },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview (file history)" },
      {
        -- Everything on this branch, committed work included. The working-tree
        -- view above goes blank once an agent has committed its changes.
        "<leader>gm",
        function()
          local base = vim.trim(vim.fn.system("git symbolic-ref --quiet --short refs/remotes/origin/HEAD"))
          if vim.v.shell_error ~= 0 or base == "" then
            base = "origin/main"
          end
          vim.cmd("DiffviewOpen " .. base .. "...HEAD")
        end,
        desc = "Diffview (vs base branch)",
      },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        -- 3-way merge conflicts are easier to read with the base shown.
        merge_tool = { layout = "diff3_mixed" },
      },
      keymaps = {
        view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
        file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
        file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
      },
    },
  },
}
