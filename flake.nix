{
  description = "A collection of custom Nix packages/modules/overlays/treats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      fenix,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: lib.genAttrs allSystems (system: f system nixpkgs.legacyPackages.${system});
      genModules =
        packages: type:
        lib.genAttrs packages (
          package:
          { lib, pkgs, ... }:
          {
            imports = [ ./${package}/${type}-module.nix ];
            programs.${package}.package = lib.mkDefault self.packages.${pkgs.system}.${package};
          }
        );
      genAllModules = genModules [
        "goclacker"
        "msedit"
        "bt-dualboot"
        "waybar-mediaplayer"
      ];
      nixosModules = genAllModules "nixos";
      homeModules = (genAllModules "home") // {
        vimPlugins =
          { lib, pkgs, ... }:
          {
            imports = [ ./vimPlugins/home-module.nix ];
            config.mornix.programs.vimPlugins = lib.mapAttrs (_: package: {
              inherit package;
            }) self.packages.${pkgs.stdenv.hostPlatform.system}.vimPlugins;
          };
      };
    in
    {
      packages = forAllSystems (
        system: pkgs: {
          goclacker = pkgs.callPackage ./goclacker/package.nix { };
          datasets = pkgs.callPackage ./datasets/package.nix { };
          msedit = pkgs.callPackage ./msedit/package.nix { fenix = fenix.packages.${system}; };
          bt-dualboot = pkgs.callPackage ./bt-dualboot/package.nix { };
          waybar-mediaplayer = pkgs.callPackage ./waybar-mediaplayer/package.nix { };
          vimPlugins = {
            cmp-mini-snippets = pkgs.callPackage ./vimPlugins/cmp-mini-snippets/package.nix { };
          };
        }
      );
      nixosModules = nixosModules // {
        default = {
          imports = lib.attrValues nixosModules;
        };
      };
      homeModules = homeModules // {
        default = {
          imports = lib.attrValues homeModules;
        };
      };
      overlays = {
        all = final: prev: self.packages.${prev.stdenv.hostPlatform.system};
        default = self.overlays.all;
      };
      formatter = forAllSystems (system: pkgs: pkgs.nixfmt-tree);
      templates = {
        standard = {
          path = ./templates/standard;
          description = "Bog standard flake";
        };
        python = {
          path = ./templates/python;
          description = "Basic Python project";
        };
        default = self.templates.standard;
      };
    };
}
