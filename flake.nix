{
  description = "A collection of custom Nix packages/modules/overlays/treats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
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
        packageNames: type:
        lib.genAttrs packageNames (
          packageName:
          { lib, pkgs, ... }:
          {
            imports = [ ./${packageName}/${type}-module.nix ];
            config.mornix.programs.${packageName}.package =
              lib.mkDefault
                self.packages.${pkgs.stdenv.hostPlatform.system}.${packageName};
          }
        );
      nixosModules = genModules [ "goclacker" ] "nixos";
      homeModules =
        (genModules [
          "bt-dualboot"
          "goclacker"
          "nix-search-cli"
          "plotprimes"
          "waybar-mediaplayer"
        ] "home")
        // {
          vimPlugins =
            { lib, pkgs, ... }:
            {
              imports = [ ./vimPlugins/home-module.nix ];
              config.mornix.programs.vimPlugins = lib.mapAttrs (_: package: {
                package = lib.mkDefault package;
              }) self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.vimPlugins;
            };
          zshPlugins =
            { lib, pkgs, ... }:
            {
              imports = [ ./zshPlugins/home-module.nix ];
              config.mornix.programs.zshPlugins = lib.mapAttrs (_: package: {
                package = lib.mkDefault package;
              }) self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.zshPlugins;
            };
        };
    in
    {
      # Package sets go in here. They will be merged into `packages` at the top level.
      legacyPackages = forAllSystems (
        system: pkgs: {
          vimPlugins = lib.recurseIntoAttrs {
            cmp-mini-snippets = pkgs.callPackage ./vimPlugins/cmp-mini-snippets/package.nix { };
          };
          zshPlugins = lib.recurseIntoAttrs {
            zimfw-completion = pkgs.callPackage ./zshPlugins/zimfw-completion/package.nix { };
            zimfw-termtitle = pkgs.callPackage ./zshPlugins/zimfw-termtitle/package.nix { };
            zimfw-environment = pkgs.callPackage ./zshPlugins/zimfw-environment/package.nix { };
            zimfw-input = pkgs.callPackage ./zshPlugins/zimfw-input/package.nix { };
          };
        }
      );
      packages = forAllSystems (
        system: pkgs:
        {
          bt-dualboot = pkgs.callPackage ./bt-dualboot/package.nix { };
          goclacker = pkgs.callPackage ./goclacker/package.nix { };
          nix-search-cli = pkgs.callPackage ./nix-search-cli/package.nix { };
          plotprimes = pkgs.callPackage ./plotprimes/package.nix { };
          waybar-mediaplayer = pkgs.callPackage ./waybar-mediaplayer/package.nix { };
        }
        // (removeAttrs (lib.mergeAttrsList (lib.attrValues self.legacyPackages.${system})) [
          "recurseForDerivations"
        ])
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
      overlays = {
        all = final: prev: self.packages.${prev.stdenv.hostPlatform.system};
        default = self.overlays.all;
      };
      formatter = forAllSystems (system: pkgs: pkgs.nixfmt-tree);
      checks = forAllSystems (system: pkgs: self.packages.${system});
    };
}
