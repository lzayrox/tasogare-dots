{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      nixfmt
      prettierd
    ];

    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 1000;
        };
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          javascript = [ "prettierd" ];
          typescript = [ "prettierd" ];
          javascriptreact = [ "prettierd" ];
          typescriptreact = [ "prettierd" ];
          json = [ "prettierd" ];
          css = [ "prettierd" ];
        };
      };
    };
  };
}
