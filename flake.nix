{
  description = "A collection of custom Nix packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
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
    in
    {
      overlays = {
        default = final: prev: {
          msedit = final.callPackage ./msedit/package.nix {
            fenix = import fenix {
              pkgs = prev;
            };
          };
          goclacker = final.callPackage ./goclacker/package.nix { };
        };
      };
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsBySystem.${system};
        in
        {
          msedit = pkgs.callPackage ./msedit/package.nix { fenix = fenix.packages.${system}; };
          goclacker = pkgs.callPackage ./goclacker/package.nix { };
          datasets = pkgs.callPackage ./datasets/package.nix { };
        }
      );
    };
}
