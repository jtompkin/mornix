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
          datasets = pkgs.callPackage ./datasets/package.nix { };
          msedit = pkgs.callPackage ./msedit/package.nix { fenix = fenix.packages.${system}; };
          mykallisto = pkgs.kallisto.overrideAttrs (oldAttrs: {
            version = "0.44.0";
            src = pkgs.fetchFromGitHub {
              repo = "kallisto";
              owner = "pachterlab";
              rev = "v0.44.0";
              sha256 = "sha256-4q3XGrS0kp6cQVs8zQxsLN55M9O7T/27VR/WJwMGStU=";
            };
          });
        }
      );
      nixosModules = (genAllModules "nixos") // {
        default = {
          imports = lib.attrValues (genAllModules "nixos");
        };
      };
      homeModules = (genAllModules "home") // {
        default = {
          imports = lib.attrValues (genAllModules "home");
        };
      };
      overlays = {
        all = final: prev: self.packages.${prev.stdenv.hostPlatform.system};
        default = self.overlays.all;
      };
    };
}
