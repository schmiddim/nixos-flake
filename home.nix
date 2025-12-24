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
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      share = true;
      ignoreAllDups = true;
    };

    shellAliases = {
      ll = "ls -lah";
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get svc";
      kctx = "kubectl config get-contexts";
      kctxu = "kubectl config use-context";
      gs = "git status";
      gl = "git log --oneline --graph --decorate";
    };

    initExtra = ''
      # ---------
      # Go
      # ---------
      export GOPATH="${config.home.homeDirectory}/go"
      export GOBIN="$GOPATH/bin"
      export PATH="$GOBIN:$PATH"

      # ---------
      # Kubernetes
      # ---------
      export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"

      # ---------
      # Prompt
      # ---------
      setopt PROMPT_SUBST
      PROMPT='%F{cyan}%n@%m%f:%F{yellow}%~%f %# '

      # ---------
      # Quality of life
      # ---------
      setopt AUTO_CD
      setopt EXTENDED_GLOB
      setopt HIST_IGNORE_SPACE
    '';
  };

  # Zsh als Default-Shell für HM-Sessions
  home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";
}
