{ ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "ls -l";

      # Navegación y Edición
      cdnix = "cd ~/dotfiles && nvim .";
      nconf = "nvim ~/dotfiles/hosts/nixos/default.nix";
      nflake = "nvim ~/dotfiles/flake.nix";

      # Reconstrucción del Sistema
      nswitch = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
      ntest = "sudo nixos-rebuild test --flake ~/dotfiles#nixos";
      nboot = "sudo nixos-rebuild boot --flake ~/dotfiles#nixos";
      ndry = "nixos-rebuild dry-build --flake ~/dotfiles#nixos";

      # Mantenimiento y Flake
      nupdate = "nix flake update --flake ~/dotfiles";
      ngc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
    };

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';

    functions = {
      agy-chat = ''
        set -l prev_dir (pwd)
        mkdir -p ~/Documents/chat
        cd ~/Documents/chat
        agy $argv
        cd $prev_dir
      '';
    };
  };
}
