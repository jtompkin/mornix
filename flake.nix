{
  description = "A collection of custom Nix packages/modules/overlays/treats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
      forAllSystems = lib.genAttrs allSystems;
      pkgsBySystem = forAllSystems (system: import nixpkgs { inherit system; });
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
      ];
      nixosModules = genAllModules "nixos";
      homeModules = genAllModules "home";
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        {
          goclacker = pkgs.callPackage ./goclacker/package.nix { };
          datasets = pkgs.callPackage ./datasets/package.nix { };
          msedit = pkgs.callPackage ./msedit/package.nix { fenix = fenix.packages.${system}; };
          bt-dualboot = pkgs.callPackage ./bt-dualboot/package.nix { };
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
        all = final: prev: self.packages.${prev.system};
        default = self.overlays.all;
      };
    };
}
