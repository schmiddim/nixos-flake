{ config, pkgs, ... }:

{
  home.username = "ms";              # <- anpassen
  home.homeDirectory = "/home/ms";   # <- anpassen
  home.stateVersion = "25.11";


  # Deine gewünschten Variablen (Home-Session)
home.sessionVariables = {
  GOPATH = "${config.home.homeDirectory}/go";
  GOBIN = "${config.home.homeDirectory}/go/bin";
  KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
};

home.sessionPath = [
  "${config.home.homeDirectory}/go/bin"
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

  # -----------------------------
  # Zsh als Login- & User-Shell
  # -----------------------------
   programs.zsh = {
      enable = true;
      enableCompletion = true;                 # Wiki (HM Beispiel) :contentReference[oaicite:6]{index=6}
      autosuggestion.enable = true;            # Wiki (HM Beispiel) :contentReference[oaicite:7]{index=7}
      syntaxHighlighting.enable = true;        # Wiki (HM Beispiel) :contentReference[oaicite:8]{index=8}

      shellAliases = {                         # Wiki (HM Beispiel) :contentReference[oaicite:9]{index=9}
        ll = "ls -l";
        edit = "sudo -e";
        update = "sudo nixos-rebuild switch";

        # deine praktischen extras:
        k = "kubectl";
        k9 = "k9s";
        gs = "git status";
      };

      history = {                              # Wiki (HM Beispiel) :contentReference[oaicite:10]{index=10}
        size = 10000;
        ignoreAllDups = true;
        path = "${config.home.homeDirectory}/.zsh_history";
        ignorePatterns = [ "rm *" "pkill *" "cp *" ];
      };

      initExtra = ''
        # Go + PATH (robust, ohne "$HOME" literal)
        export GOPATH="${config.home.homeDirectory}/go"
        export GOBIN="$GOPATH/bin"
        export PATH="$GOBIN:$PATH"

        # k3s kubeconfig
        export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
      '';
    };


  # Zsh als Default-Shell für HM-Sessions
  home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";
}
