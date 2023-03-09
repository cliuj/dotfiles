ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

XDG_CONFIG_HOME="$(HOME)/.config"

.PHONY: all install configs pkgs

install: install-yay

install-yay:
	echo "Installing AUR helper: `yay` via local compile"
	sudo pacman -S --needed git base-devel \
	&& mkdir ~/aur \
	&& cd ~/aur \
	&& git clone https://aur.archlinux.org/yay.git \
	|| true \
	&& cd yay \
	&& makepkg -sri

pkgs: pkgs-pacman pkgs-yay

pkgs-pacman:
	echo "Installing packages listed in *.pacman files via pacman"
	cd pkglists \
	&& cat *.pacman \
	| sudo pacman -S -

pkgs-yay:
	echo "Installing AUR packages listed in *.yay files via yay"
	cd pkglists \
	&& cat *.yay \
	| yay -S -

configs: config-vendir config-xdg config-x

config-vendir:
	echo "Retrieving configs via vendir"
	vendir sync -f "$(ROOT_DIR)/vendir.yml" --chdir "$(HOME)"

config-xdg:
	echo "Linking user-dirs.dirs"
	ln -sf "$(ROOT_DIR)/user-dirs.dirs" "$(XDG_CONFIG_HOME)"

config-x:
	echo "Linking .xinitrc"
	ln -sf "$(ROOT_DIR)/.xinitrc" ~/.xinitrc

all: install pkgs configs
