{ ... }:
{
  programs.nixvim.plugins = {
    render-markdown.enable = true;

    markdown-preview = {
      enable = true;
      settings = {
        auto_close = 1;
        theme = "dark";
      };
    };
  };
}
