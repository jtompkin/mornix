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
            programs.${package}.package =
              lib.mkDefault
                self.packages.${pkgs.stdenv.hostPlatform.system}.${package};
          }
        );
      genAllModules = genModules [
        "goclacker"
        "msedit"
      ];
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        {
          goclacker = pkgs.callPackage ./goclacker/package.nix { };
          msedit = pkgs.callPackage ./msedit/package.nix { fenix = fenix.packages.${system}; };
        }
      );
      nixosModules = genAllModules "nixos";
      homeModules = genAllModules "home";
      overlays = {
        default =
          final: prev: with self.packages.${prev.stdenv.hostPlatform.system}; {
            inherit goclacker msedit;
          };
      };
    };
}
