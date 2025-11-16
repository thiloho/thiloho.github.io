{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.trusted-users = [ "thohlt" ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  networking = {
    networkmanager.enable = true;
    hostName = "nixos-server";
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
    };
  };

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      virtualHosts = {
        "redlib.thilohohlt.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:${toString config.services.redlib.port}";
            proxyWebsockets = true;
          };
        };
        "git.thilohohlt.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:${toString config.services.gitea.settings.server.HTTP_PORT}";
            proxyWebsockets = true;
          };
        };
        "music.thilohohlt.com" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:${toString config.services.navidrome.settings.Port}";
            proxyWebsockets = true;
          };
        };
      };
    };
    redlib = {
      enable = true;
      port = 2222;
      address = "127.0.0.1";
    };
    gitea = {
      enable = true;
      database = {
        type = "postgres";
        host = "/run/postgresql";
        port = 5432;
      };
      settings = {
        server = {
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = 3333;
        };
        service = {
          DISABLE_REGISTRATION = true;
        };
        session = {
          COOKIE_SECURE = true;
        };
      };
    };
    navidrome = {
      enable = true;
      settings = {
        Port = 4444;
        Address = "127.0.0.1";
        MusicFolder = "/home/thohlt/Music";
      };
    };
    postgresql = {
      enable = true;
      ensureDatabases = [ "gitea" ];
      ensureUsers = [
        {
          name = "gitea";
          ensureDBOwnership = true;
        }
      ];
    };
    minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true;
      declarative = true;
      whitelist = {
        "3xt1nct" = "4e4d744d-7748-46bc-add8-b3e8ca3b4cf5";
      };
      serverProperties = {
        difficulty = "hard";
        max-players = 5;
        motd = "Thilo's SMP Server";
        white-list = true;
      };
      jvmOpts = "-Xms1024M -Xmx2048M";
    };
  };

  systemd.tmpfiles.rules = [
    "a /home/thohlt - - - - u:navidrome:--x"
    "A /home/thohlt/Music - - - - u:navidrome:r-X,d:u:navidrome:r-X"
  ];

  systemd.services.navidrome.serviceConfig.ProtectHome = lib.mkForce false;

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "contact@thilohohlt.com";
    };
  };

  users.users.thohlt = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDvf71FYha3PYUlOfc1rh+qZaGd6zzqYAIfecV2K6td thohlt@archlinux"
    ];
  };

  system.stateVersion = "25.11";
}
