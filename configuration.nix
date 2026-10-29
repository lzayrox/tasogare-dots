# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  pkgs,
  inputs,
  ...
}:
let
  trccPkg = inputs.trcc-linux.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --sessions /run/current-system/sw/share/wayland-sessions --cmd 'uwsm start hyprland-uwsm.desktop'";
        user = "greeter";
      };
    };
  };

  services.flatpak.enable = true;

  systemd.services.thermalright-trcc = {
    description = "Thermalright Digital Screen Background Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${trccPkg}/bin/trcc serve"; # O el comando/flags exactos con los que funcionó
      Restart = "always";
      RestartSec = "5s";
    };
  };

  # Set your time zone.
  time.timeZone = "America/Bogota";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.fish.enable = true;

  programs.trcc-linux.enable = true;

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

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals.mapleader = " ";

    extraPackages = with pkgs; [
      nixfmt
      prettierd
    ];

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 4;
      tabstop = 4;
      expandtab = true;
      cursorline = true;
    };

    files."ftplugin/nix.lua" = {
      localOpts = {
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = ":Neotree toggle<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>f";
        action = "<cmd>lua vim.lsp.buf.format()<CR>";
        options.silent = true;
      }
    ];

    colorschemes.kanagawa = {
      enable = true;
      settings = {
        theme = "wave";
        transparent = true;
      };
    };

    plugins = {
      treesitter.enable = true;
      web-devicons.enable = true;
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
        };
      };

      indent-blankline = {
        enable = true;
        settings = {
          scope = {
            show_start = true;
            show_end = false;
          };
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 1000;
          };
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            javascriptreact = [ "prettierd" ];
            typescriptreact = [ "prettierd" ];
            json = [ "prettierd" ];
            css = [ "prettierd" ];
          };
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = "find_files";
          "<leader>fg" = "live_grep";
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        settings.mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping.select_next_item()";
          "<S-Tab>" = "cmp.mapping.select_prev_item()";
        };
      };

      lsp = {
        enable = true;
        servers = {
          #Nix
          nixd.enable = true;

          # Fullstack
          ts_ls.enable = true;
          eslint.enable = true;

          # Frontend
          tailwindcss.enable = true;
          html.enable = true;
          cssls.enable = true;

          # Config & Infra
          jsonls.enable = true;
          yamlls.enable = true;
          dockerls.enable = true;

          # shell
          bashls.enable = true;
        };

        keymaps = {
          lspBuf = {
            "gd" = "definition";
            "gr" = "references";
            "K" = "hover";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
        };
      };

    };
  };

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  home-manager.users.lzirox = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    imports = [
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];

    home.username = "lzirox";
    home.homeDirectory = "/home/lzirox";
    home.stateVersion = "26.05";

    home.packages = with pkgs; [
      wofi
      grim
      slurp
      kdePackages.dolphin
      fastfetch
      quickshell
      steam
      antigravity-cli
    ];

    programs.kitty = {
      enable = true;
      settings = {
        font_size = 11;
        confirm_os_window_close = 0;
        background_opacity = 0.75;
      };
    };

    programs.firefox = {
      enable = true;
    };

    programs.waybar = {
      enable = true;
    };

    programs.fish = {
      enable = true;
      shellAliases = {
        ls = "ls -l";
        nconf = "nvim /etc/nixos/configuration.nix";
        nflake = "nvim /etc/nixos/flake.nix";
        cdnix = "cd /etc/nixos && nvim .";
        nswitch = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
        ntest = "sudo nixos-rebuild test --flake /etc/nixos#nixos";
        nupdate = "nix flake update --flake /etc/nixos";
      };
      interactiveShellInit = ''
        set -g fish_greeting ""
      '';
      plugins = [ ];
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

    services.flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      packages = [
        "app.zen_browser.zen"
      ];
    };

  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    git
    kitty
    wget
    curl
    gnumake
    pkg-config
    cmake
    gcc
    wl-clipboard
    libnotify
    matugen
    uwsm

    # Qt6 / QML dependcies
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg

    # Programing
    python314
    uv
    nodejs
    pnpm

    protobuf
    openssl
    trccPkg
    docker
    docker-compose
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    (vscode.override {
      commandLineArgs = "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations";
    })
  ];

  fonts.packages =
    with pkgs;
    [
      nerd-fonts.jetbrains-mono
      font-awesome
      noto-fonts-color-emoji
    ]
    ++ (with inputs.apple-fonts.packages.${pkgs.system}; [
      sf-mono
      sf-mono-nerd
      sf-pro
    ]);

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05"; # Did you read the comment?
}
