{ ... }:
{
  programs.nixvim = {
    colorschemes.kanagawa = {
      enable = true;
      settings = {
        theme = "wave";
        transparent = true;
      };
    };

    plugins = {
      treesitter.enable = true;
      web-devicons.enable = true;

      neo-tree = {
        enable = true;
        settings.close_if_last_window = true;
      };

      indent-blankline = {
        enable = true;
        settings.scope = {
          show_start = true;
          show_end = false;
        };
      };
    };
  };
}
