{ pkgs, config, ... }:
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
      };
    };
    redlib = {
      enable = true;
      port = 2222;
      address = "127.0.0.1";
    };
  };

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

  system.stateVersion = "25.10";
}
