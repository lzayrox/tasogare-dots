{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    jq
    git
    wget
    curl
    pciutils
    usbutils
  ];
}
