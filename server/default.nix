{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

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

  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;

  networking = {
    networkmanager.enable = true;
    hostName = "nixos-server";
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [
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
        };
      };
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
