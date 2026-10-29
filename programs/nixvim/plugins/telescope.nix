{ ... }:
{
  programs.nixvim.plugins.telescope = {
    enable = true;
    keymaps = {
      "<C-p>" = "find_files";
      "<leader>fg" = "live_grep";
    };
  };
}
