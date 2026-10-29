{ inputs, ... }:
{
  home-manager.users.lzirox = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    imports = [
      inputs.nix-flatpak.homeManagerModules.nix-flatpak

      # Programas
      ./programs/kitty.nix
      ./programs/firefox.nix
      ./programs/vscode.nix

      # Shell
      ./shell/fish.nix
    ];

    home.username = "lzirox";
    home.homeDirectory = "/home/lzirox";
    home.stateVersion = "26.05";

    home.packages = with pkgs; [
      # Escritorio
      wofi
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
      inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default

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
