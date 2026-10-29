{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      brotli
      unixodbc
      glib
      zstd
      stdenv.cc.cc
    ];
  };
}
