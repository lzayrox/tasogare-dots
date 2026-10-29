{ pkgs, inputs, ... }:
let
  trccPkg = inputs.trcc-linux.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  programs.trcc-linux.enable = true;

  systemd.services.thermalright-trcc = {
    description = "Thermalright Digital Screen Background Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${trccPkg}/bin/trcc serve";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
