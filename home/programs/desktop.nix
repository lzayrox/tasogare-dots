{ config, ... }:
let
  dotDir = "${config.home.homeDirectory}/dotfiles/home/config";
in
{
  xdg.configFile = {
    "hypr".source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/hypr";
    "quickshell".source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/quickshell";
    "matugen".source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/matugen";
    "kitty".source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/kitty";
  };
}
