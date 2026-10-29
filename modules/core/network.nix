{ ... }:
{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  #networking.firewall.allowedTCPPorts = [ ... ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
}
