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
      nixosModules = genModules [ "msedit" "goclacker" ] "nixos";
      homeModules =
        (genModules [
          "bt-dualboot"
          "goclacker"
          "msedit"
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
              }) self.packages.${pkgs.stdenv.hostPlatform.system}.vimPlugins;
            };
        };
    in
    {
      packages = forAllSystems (
        system: pkgs: {
          bt-dualboot = pkgs.callPackage ./bt-dualboot/package.nix { };
          datasets = pkgs.callPackage ./datasets/package.nix { };
          goclacker = pkgs.callPackage ./goclacker/package.nix { };
          msedit = pkgs.callPackage ./msedit/package.nix { fenix = fenix.packages.${system}; };
          nix-search-cli = pkgs.callPackage ./nix-search-cli/package.nix { };
          plotprimes = pkgs.callPackage ./plotprimes/package.nix { };
          vimPlugins = {
            cmp-mini-snippets = pkgs.callPackage ./vimPlugins/cmp-mini-snippets/package.nix { };
          };
          zshPlugins = {
            zimfw-completion = pkgs.callPackage ./zshPlugins/zimfw-completion/package.nix { };
            zimfw-termtitle = pkgs.callPackage ./zshPlugins/zimfw-termtitle/package.nix { };
            zimfw-environment = pkgs.callPackage ./zshPlugins/zimfw-environment/package.nix { };
            zimfw-input = pkgs.callPackage ./zshPlugins/zimfw-input/package.nix { };
          };
          waybar-mediaplayer = pkgs.callPackage ./waybar-mediaplayer/package.nix { };
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
