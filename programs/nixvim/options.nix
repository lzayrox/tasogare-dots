{ ... }:
{
  programs.nixvim = {
    opts = {
      clipboard = "unnamedplus";
      conceallevel = 2;
      number = true;
      relativenumber = true;
      shiftwidth = 4;
      tabstop = 4;
      expandtab = true;
      cursorline = true;
    };

    files."ftplugin/nix.lua" = {
      localOpts = {
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
      };
    };
  };
}
