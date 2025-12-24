FLAKE ?= .#ms-nixos
.PHONY: switch update

# Rebuild the system from the local flake.
switch:
	sudo nixos-rebuild switch --flake $(FLAKE)

# Update flake inputs to their latest versions.
update:
	nix flake update
