{ pkgs, inputs, ... }:
let
  quickshellSrc = ../../home/config/quickshell;
in
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;

  # Única fuente de verdad para variables de sesión y cursores en todo el sistema
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    UWSM_SILENT_START = "2";
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_THEME = "BreezeX-RosePine-Linux";
    XCURSOR_SIZE = "24";
  };

  environment.pathsToLink = [ "/share/icons" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Dependencias gráficas de sesión, cursores y Qt
  environment.systemPackages = with pkgs; [
    cage
    uwsm
    rose-pine-cursor
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.writeShellScript "greetd-session" ''
          CARD_DEDICATED=$(readlink -f /dev/dri/by-path/pci-0000:03:00.0-card 2>/dev/null || true)
          CARD_INTEGRATED=$(readlink -f /dev/dri/by-path/pci-0000:0e:00.0-card 2>/dev/null || true)

          if [ -n "$CARD_DEDICATED" ] && [ -e "$CARD_DEDICATED" ]; then
            if [ -n "$CARD_INTEGRATED" ] && [ -e "$CARD_INTEGRATED" ]; then
              export WLR_DRM_DEVICES="$CARD_DEDICATED:$CARD_INTEGRATED"
            else
              export WLR_DRM_DEVICES="$CARD_DEDICATED"
            fi
          fi

          exec ${pkgs.cage}/bin/cage -s -- ${pkgs.quickshell}/bin/quickshell -p ${quickshellSrc}/greetd >/dev/null 2>&1
        ''}";
        user = "greeter";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/cache/greeter 0777 greeter greeter -"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
