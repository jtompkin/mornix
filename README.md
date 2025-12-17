# mornix

A collection of custom Nix packages/modules/overlays/treats.

The goal here is to utilize the module system to limit or remove the need to use overlays to install custom software and different versions of software. By providing a module for each package, you can specify the specific version of each package to use in the `package` config option. Then, you can reference this package throughout the rest of your Nix config. This is much cleaner than overlays, which are gross.

## What's inside?

### Packages!

### [bt-dualboot](https://github.com/x2es/bt-dualboot): sync Bluetooth for dualboot Linux and Windows

- **Reason for inclusion**: not available in Nixpkgs
- **Provided**: Nix package, Home Manager module

### [datasets](https://github.com/ncbi/datasets): gather data from across NCBI databases

- **Reason for inclusion**: not available in Nixpkgs
- **Provided**: Nix package

### [goclacker](https://github.com/jtompkin/goclacker): command line reverse Polish notation (RPN) calculator

- **Reason for inclusion**: egotistical bias, not available in Nixpkgs
- **Provided**: Nix package, Home Manager module, NixOS module

### [edit (msedit)](https://github.com/microsoft/edit): command line editor by Microsoft

- **Reason for inclusion**: learning, used to not be available in Nixpkgs
- **Provided**: Nix package recipe
- **REMOVED**: No longer included in flake to trim inputs; recipe still available in `package.nix`

### [nix-search-cli](https://github.com/peterldowns/nix-search-cli): CLI for searching packages on search.nixos.org

- **Reason for inclusion**: old version available in Nixpkgs, author's flake does not provide modules
- **Provided**: Nix package, Home Manager module

### [plotprimes](https://github.com/jtompkin/plot-primes): make nice polar plots of prime numbers

- **Reason for inclusion**: egotistical bias, not available in Nixpkgs
- **Provided**: Nix package, Home Manager module

### [waybar-mediaplayer](https://github.com/Alexays/Waybar/blob/master/resources/custom_modules/mediaplayer.py): custom Waybar module to show and play media

- **Reason for inclusion**: not available in Nixpkgs
- **Provided**: Nix package, Home Manager module

### Vim (Neovim) plugins:

- **Provided for all plugins**: Nix package, Home Manager module
- **[cmp-mini-snippets](https://github.com/abeldekat/cmp-mini-snippets)**
  - **Reason for inclusion**: not available in Nixpkgs

### Templates!

- **standard**: bog standard flake
- **python**: basic python project

### Modules!

Most packages provide at least a minimal Home Manager and/or NixOS module that defines an `enable` option and a `package` option in the `mornix.programs` namespace. The `package` option is set by default to the corresponding package built by this flake, but can of course be overridden. Usually, the enable option will just add the package to your home or system packages list.

## Usage

Add the flake to your inputs, and then import the default module to get all the modules. You can import specific modules too.

```nix
{
  inputs = {
    home-manager.url = "...";
    mornix.url = "github:jtompkin/mornix/main";
  };
  outputs =
    {
      self,
      mornix,
      home-manager,
    }:
    {
      homeConfigurations."chrundle@paddys" = home-manager.lib.homeManagerConfiguration {
        pkgs = "...";
        modules = [
          (
            {
              config,
              pkgs,
              lib,
            }:
            {
              imports = [ mornix.homeModules.default ]; # or just: mornix.homeModules.goclacker
              config = {
                mornix.programs.goclacker.enable = true;
                # Replace the package with your own
                #mornix.programs.goclacker.package = pkgs.callPackage ./custom/package.nix { };
                # Grab the package from the config
                #some.made.up.option = lib.getExe config.mornix.programs.goclacker.package;
              };
            }
          )
        ];
      };
    };
}
```

If you are a masochist, feel free to browse [my Nix config](https://github.com/jtompkin/dotfiles) to see how I utilize this flake.
