SUDO ?= sudo
NIXOS_CONFIG ?= ./configuration.nix
HM_CONFIG ?= ./home.nix

.PHONY: help system-switch home-switch switch-all update update-home

help:
	@echo "Targets:"
	@echo "  (1) system-switch   - nixos-rebuild switch (Home Manager als NixOS-Modul läuft mit)"
	@echo "  (2) home-switch     - home-manager switch (nur wenn standalone installiert/benutzt)"
	@echo "  (3) switch-all      - (1) dann (2)"
	@echo "  (4) update          - nix-channel --update + nixos-rebuild switch --upgrade"
	@echo "  (5) update-home     - home-manager switch (standalone) + ggf. channel update"

system-switch:
	$(SUDO) nixos-rebuild switch -I nixos-config=$(NIXOS_CONFIG)

home-switch:
	@command -v home-manager >/dev/null 2>&1 && \
	  home-manager switch -f $(HM_CONFIG) || \
	  (echo "home-manager nicht gefunden (oder nicht standalone). Bei HM als NixOS-Modul reicht: make system-switch"; exit 0)

switch-all: system-switch home-switch

update:
	$(SUDO) nix-channel --update
	$(SUDO) nixos-rebuild switch --upgrade -I nixos-config=$(NIXOS_CONFIG)

update-home:
	@command -v home-manager >/dev/null 2>&1 && \
	  (nix-channel --update && home-manager switch -f $(HM_CONFIG)) || \
	  (echo "home-manager nicht gefunden (oder nicht standalone)."; exit 0)
