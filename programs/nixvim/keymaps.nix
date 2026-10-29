{ ... }:
{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = ":Neotree toggle<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<leader>f";
      action = "<cmd>lua vim.lsp.buf.format()<CR>";
      options.silent = true;
    }
  ];
}
