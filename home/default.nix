{ inputs, ... }:
{
  home-manager.users.lzirox = { pkgs, config, ... }: {
    nixpkgs.config.allowUnfree = true;

    imports = [
      inputs.nix-flatpak.homeManagerModules.nix-flatpak

      # Programas
      ./programs/firefox.nix
      ./programs/vscode.nix
      ./programs/desktop.nix

      # Shell
      ./shell/fish.nix
    ];

    home.username = "lzirox";
    home.homeDirectory = "/home/lzirox";
    home.stateVersion = "26.05";

    home.sessionVariables = {
      NH_FLAKE = "${config.home.homeDirectory}/dotfiles";
    };

    home.sessionPath = [
      "${config.home.homeDirectory}/.config/quickshell/bin"
    ];

    home.packages = with pkgs; [
      # Escritorio
      wofi
      kitty
      grim
      slurp
      kdePackages.dolphin
      fastfetch
      quickshell
      steam
      antigravity-cli

      # Utilidades Hyprland / Wayland
      wl-clipboard
      libnotify
      matugen
      playerctl
      brightnessctl

      # Lenguajes y Gestores de Paquetes
      python314
      uv
      nodejs
      pnpm

      # Herramientas de desarrollo
      gcc
      gnumake
      cmake
      pkg-config
      protobuf
      openssl
      docker-compose
    ];

    services.flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      packages = [
        "app.zen_browser.zen"
      ];
    };
  };
}
