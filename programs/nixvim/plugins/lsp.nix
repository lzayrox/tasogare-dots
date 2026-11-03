{ ... }:
{
  programs.nixvim.plugins.lsp = {
    enable = true;
    onAttach = ''
      client.server_capabilities.semanticTokensProvider = nil
    '';
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

      # Python
      pyright.enable = true;

      # QML / Quickshell
      qmlls.enable = true;

      # Lua
      lua_ls = {
        enable = true;
        settings.telemetry.enable = false;
      };

      # TOML
      taplo.enable = true;

      # Shell
      bashls.enable = true;

      # Markdown
      marksman.enable = true;
    };

    keymaps = {
      lspBuf = {
        "gd" = "definition";
        "gr" = "references";
        "K" = "hover";
        "<leader>rn" = "rename";
        "<leader>ca" = "code_action";
      };
    };
  };
}
