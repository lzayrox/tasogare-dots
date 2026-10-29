{ ... }:
{
  imports = [
    # Hardware
    ./hardware.nix

    # Home Manager
    ../../home/default.nix

    # Modules Core
    ../../modules/core/nix.nix
    ../../modules/core/nix-ld.nix
    ../../modules/core/packages.nix
    ../../modules/core/boot.nix
    ../../modules/core/network.nix
    ../../modules/core/locale.nix
    ../../modules/core/users.nix
    ../../modules/core/docker.nix

    # Modules Desktop
    ../../modules/desktop/audio.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/fonts.nix

    # Modules Services
    ../../modules/services/flatpak.nix
    ../../modules/services/trcc.nix

    # Programs
    ../../programs/nixvim/default.nix
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
