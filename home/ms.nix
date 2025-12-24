{ config, pkgs, ... }:
{
  home.username = "ms";
  home.homeDirectory = "/home/ms";
  home.stateVersion = "24.05";

  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    PATH = "$HOME/go/bin:$PATH";
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;
        modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
        modules-center = [ ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "clock" "tray" ];
      };
    };
    style = ''
      * {
        font-family: "Noto Sans", "Font Awesome 6 Free";
        font-size: 12pt;
      }
      window#waybar {
        background: #1d1f21;
        color: #c5c8c6;
      }
    '';
  };

  programs.foot.enable = true;

  programs.bemenu = {
    enable = true;
    settings = {
      font = "Noto Sans 11";
      ignorecase = true;
    };
  };

  programs.swaylock.enable = true;


  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      menu = "bemenu-run";
      input = {
        ".*" = {
          xkb_layout = "de";
        };
      };
      output = {
        "*" = {
          bg = "#1d1f21 solid_color";
        };
      };
      bars = [
        {
          command = "waybar";
        }
      ];
      keybindings = let
        mod = "Mod4";
      in {
        "${mod}+Return" = "exec foot";
        "${mod}+q" = "kill";
        "${mod}+d" = "exec bemenu-run";
        "${mod}+Shift+e" = ''exec swaymsg exit'';
        "${mod}+Shift+r" = "reload";
        "${mod}+l" = "exec swaylock";
        "${mod}+Shift+c" = "reload";
        "${mod}+f" = "fullscreen";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        "${mod}+space" = "floating toggle";
        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+Shift+q" = "kill";
        "${mod}+Shift+space" = "focus mode_toggle";
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";
      };
      startup = [
        { command = "systemctl --user start pipewire wireplumber"; }
        { command = "swayidle -w"; }
      ];
    };
  };
}
