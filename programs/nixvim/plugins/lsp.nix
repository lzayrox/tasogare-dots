{ ... }:
{
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      # Nix
      nixd.enable = true;

      # Fullstack
      ts_ls.enable = true;
      eslint.enable = true;

      # Frontend
      tailwindcss.enable = true;
      html.enable = true;
      cssls.enable = true;

      # Config & Infra
      jsonls.enable = true;
      yamlls.enable = true;
      dockerls.enable = true;

      # Shell
      bashls.enable = true;
    };

    keymaps = {
      lspBuf = {
        "gd" = "definition";
        "gr" = "references";
        "K" = "hover";
        "<leader>rn" = "rename";
        "<leader>ca" = "code_action";
      };
      diagnostic = {
        "[d" = "goto_prev";
        "]d" = "goto_next";
      };
    };
  };
}
