{
  description = "Bog standard flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      allSystems = [ "x86_64-linux" ];
      forAllSystems = f: lib.genAttrs allSystems (system: f system nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        system: pkgs: {
          hello = pkgs.callPackage ./package.nix { };
          default = self.packages.${system}.hello;
        }
      );
      devShells = forAllSystems (
        system: pkgs: {
          default = pkgs.mkShell {
            name = "nix-shell";
            packages = [ ];
          };
        }
      );
    };
}
