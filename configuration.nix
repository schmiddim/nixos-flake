{ config, pkgs, ... }:

let
  # Home Manager als NixOS-Modul (laut Wiki-Template)
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
  ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # --- Basics ---
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  # Für Sway via Home Manager: Polkit muss an sein
  security.polkit.enable = true; # required per Sway wiki :contentReference[oaicite:1]{index=1}

  # Optional, aber in der Praxis oft nötig (GTK themes, portals etc.)
  programs.dconf.enable = true; # HM wiki FAQ hint :contentReference[oaicite:2]{index=2}

  # Wayland portals (wichtig für Screensharing/xdg-desktop-portal unter Sway)
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # --- Sway (System-Seite) ---
  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;

  # Greeter (laut Sway wiki: greetd + tuigreet ist straightforward)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  }; # :contentReference[oaicite:3]{index=3}

  # Sound (einfacher Default)
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  security.rtkit.enable = true;

  # --- k3s ---
  services.k3s = {
    enable = true;
    role = "server";
    # damit dein User kubectl ohne sudo nutzen kann:
    extraFlags = [ "--write-kubeconfig-mode=644" ];
  };
  networking.firewall.allowedTCPPorts = [ 6443 ];
  networking.firewall.allowedUDPPorts = [ 8472 ]; # flannel vxlan (häufig nötig)

  # KUBECONFIG global verfügbar machen (du wolltest /etc/rancher/k3s/k3s.yaml)
  environment.sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

  # --- User (bitte anpassen) ---
  users.users.ms = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # --- Pakete (Systemweit) ---
  environment.systemPackages = with pkgs; [
    vim wget htop git gnumake gcc usbutils
    thunderbird
    google-chrome
    jetbrains.idea-ultimate
    freecad gimp

    go gotools gh kubectl k9s
  ];

  # --- Home Manager Einbindung ---
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.ms = import ./home.nix;
  };

  system.stateVersion = "25.11";
}
