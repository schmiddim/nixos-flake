{ config, pkgs, ... }:

{
  home.username = "ms";              # <- anpassen
  home.homeDirectory = "/home/ms";   # <- anpassen
  home.stateVersion = "25.11";

  # Deine gewünschten Variablen (Home-Session)
  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  # PATH erweitern (sauber über HM)
  home.sessionPath = [
    "$HOME/go/bin"
  ];

  # Sway via Home Manager
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    # sorgt dafür, dass user systemd/Env sauber übernommen wird
    systemd.variables = [ "--all" ]; # :contentReference[oaicite:7]{index=7}

    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "${pkgs.wofi}/bin/wofi --show drun";

      # Beispiel: deutsches Layout (optional)
      input."*".xkb_layout = "de";

      startup = [
        { command = "${pkgs.mako}/bin/mako"; }
        { command = "${pkgs.waybar}/bin/waybar"; }
      ];

      keybindings = pkgs.lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Shift+e" = "exec ${pkgs.sway}/bin/swaymsg exit";
      };
    };

    # Wichtig: NixOS Sway-Integration (dbus/systemd/portals) mitnehmen
    extraConfig = ''
      include /etc/sway/config.d/*
    '';
  };

  # Secret Service (Wiki-Empfehlung)
  services.gnome-keyring.enable = true; # :contentReference[oaicite:8]{index=8}

  # Praktische Wayland-Tools (Sway-Umfeld)
  home.packages = with pkgs; [
    alacritty
    waybar mako wofi
    grim slurp wl-clipboard
    swaylock swayidle
  ];

  # Optional: HM verwaltet Shell → sorgt dafür, dass hm-session-vars zuverlässig geladen werden kann
  # (Wiki erwähnt: Shell-Konfig via HM ist der bequemste Weg)
  programs.bash.enable = true; # :contentReference[oaicite:9]{index=9}
}
