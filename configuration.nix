{ config, pkgs, ... }:
{
  imports = [ ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  networking.hostName = "ms-nixos";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  console = {
    keyMap = "de";
  };

  users.users.ms = {
    isNormalUser = true;
    description = "ms";
    extraGroups = [ "wheel" "networkmanager" "video" "seat" ];
    initialPassword = "changeme";
    home = "/home/ms";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    git
    gnumake
    gcc
    usbutils
    thunderbird
    google-chrome
    jetbrains.idea
    freecad
    gimp
    go
    gotools
    gh
    kubectl
    k9s

    sway
    swaylock
    swayidle
    waybar
    foot
    bemenu
    grim
    slurp
    wl-clipboard
    wtype
    mako
  ];

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
  services.pulseaudio.enable = false;

  security.polkit.enable = true;
  services.dbus.enable = true;
  programs.dconf.enable = true;

  services.seatd.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd sway";
      user = "greeter";
    };
  };

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [
      "--write-kubeconfig-mode=644"
      "--disable=traefik"
    ];
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };

  hardware.graphics.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    font-awesome
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.11";

}
