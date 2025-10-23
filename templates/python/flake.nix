{
  description = "Basic Python project";

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
          project_name = pkgs.callPackage ./nix/package.nix { };
          default = self.packages.${system}.project_name;
        }
      );
      devShells = forAllSystems (
        system: pkgs: {
          default = pkgs.mkShell {
            name = "python";
            packages = [
              (pkgs.python3.withPackages (
                python-pkgs: with python-pkgs; [
                  numpy
                ]
              ))
            ];
          };
        }
      );
    };
}
