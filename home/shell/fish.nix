{ ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "ls -l";

      # Navegación y Edición
      cdnix = "cd ~/dotfiles && nvim .";
      cddesk = "cd ~/dotfiles/home/config && nvim .";
      nconf = "nvim ~/dotfiles/hosts/nixos/default.nix";
      nflake = "nvim ~/dotfiles/flake.nix";

      # Reconstrucción del Sistema
      nswitch = "git -C ~/dotfiles add -A && nh os switch";
      ntest = "git -C ~/dotfiles add -A && nh os test";
      nboot = "git -C ~/dotfiles add -A && nh os boot";
      ndry = "git -C ~/dotfiles add -A && nh os switch --dry";

      # Mantenimiento y Flake
      nupdate = "git -C ~/dotfiles add -A && nh os switch -u";
      ngc = "nh clean all --keep 3";
    };

    interactiveShellInit = ''
      set -g fish_greeting ""

      # Cargar scripts y funciones modulares
      if test -f ~/dotfiles/home/shell/scripts/agy.fish
          source ~/dotfiles/home/shell/scripts/agy.fish
      end
      if test -f ~/dotfiles/home/shell/scripts/tasogare.fish
          source ~/dotfiles/home/shell/scripts/tasogare.fish
      end
    '';

    functions = {
      deskconf = ''
        set -l base_dir ~/dotfiles/home/config

        if test (count $argv) -eq 0
            cd $base_dir; and nvim .
        else
            if test -d $base_dir/$argv[1]
                cd $base_dir/$argv[1]; and nvim .
            else
                echo "No se encontró '$argv[1]' en $base_dir"
            end
        end
      '';
    };
  };
}
