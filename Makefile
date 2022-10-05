ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

XDG_CONFIG_HOME="$(HOME)/.config"

all: dirs links install switch

dirs:
	mkdir -p "$(ROOT_DIR)/.xmonad"

links:
	ln -sf "$(ROOT_DIR)/configs/nvim" "$(XDG_CONFIG_HOME)"
	ln -sf "$(ROOT_DIR)/configs/xmobar" "$(XDG_CONFIG_HOME)"
	ln -sf "$(ROOT_DIR)/configs/kitty" "$(XDG_CONFIG_HOME)"
	ln -sf "$(ROOT_DIR)/nixpkgs" "$(XDG_CONFIG_HOME)"
	ln -sf "$(ROOT_DIR)/xmonad" "$(HOME)/.xmonad"

install:
	nix-shell '<home-manager> -A install'

switch:
	home-manager switch

clean:
	rm -f "$(XDG_CONFIG_HOME)/nvim"
	rm -f "$(XDG_CONFIG_HOME)/xmobar"
	rm -f "$(XDG_CONFIG_HOME)/kitty"
	rm -f "$(XDG_CONFIG_HOME)/nixpkgs"
	rm -f "$(HOME)/.xmonad"
