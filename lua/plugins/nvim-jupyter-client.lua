return {
  "geg2102/nvim-jupyter-client",
  ft = { "jupyter", "ipynb" },
  keys = {
    -- Add cells
    { "<leader>ja", "<cmd>JupyterAddCellBelow<CR>", mode = "n", desc = "Add Jupyter cell below" },
    { "<leader>jA", "<cmd>JupyterAddCellAbove<CR>", mode = "n", desc = "Add Jupyter cell above" },
    -- Cell operations
    { "<leader>jd", "<cmd>JupyterRemoveCell<CR>", mode = "n", desc = "Remove current Jupyter cell" },
    { "<leader>jD", "<cmd>JupyterDeleteCell<CR>", mode = "n", desc = "Delete cell and store in register" },
    { "<leader>jm", "<cmd>JupyterMergeCellAbove<CR>", mode = "n", desc = "Merge with cell above" },
    { "<leader>jM", "<cmd>JupyterMergeCellBelow<CR>", mode = "n", desc = "Merge with cell below" },
    { "<leader>jt", "<cmd>JupyterConvertCellType<CR>", mode = "n", desc = "Convert cell type (code/markdown)" },
    { "<leader>jm", "<cmd>JupyterMergeVisual<CR>", mode = "v", desc = "Merge selected cells" },
  },
  config = function()
    require("nvim-jupyter-client").setup({})
  end,
}
