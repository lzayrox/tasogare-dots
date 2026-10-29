{ ... }:
{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins/ui.nix
    ./plugins/telescope.nix
    ./plugins/conform.nix
    ./plugins/cmp.nix
    ./plugins/lsp.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    globals.mapleader = " ";
  };
}
