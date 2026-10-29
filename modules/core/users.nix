{ pkgs, ... }:
{
  programs.fish.enable = true;

  users.users."lzirox" = {
    isNormalUser = true;
    description = "Zirox";
    extraGroups = [
      "networkmanager"
      "wheel"
      "trcc"
      "docker"
    ];
    shell = pkgs.fish;
  };

  security.rtkit.enable = true;
}
