# dotfiles

### Install
For quick setup, installation is done via `make` targets.

#### all
Installs and sets up everything via running all the `make` targets
> **Note**: This is meant to be used on freshly setup **Arch** system as
>           some steps (like `git clone`) may fail if the target directory
>           exists
```bash
make all
```

#### install
Installs miscellaneous pkgs that aren't installed through a package manager.
```bash
make install
```

#### pkgs
Installs only the packages listed in `pkglist/` files.
```bash
make pkgs
```

#### configs
Setups miscellaneous config files located in this repo.
```bash
make configs
```
