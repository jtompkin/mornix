/*
  This file is licensed under the terms of the LICENSE file found in the root directory
  of this repository (https://github.com/jtompkin/mornix), not the LICENSE file found in
  this directory
*/
{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.nix-search-cli;
in
{
  options.mornix.programs.nix-search-cli = {
    enable = lib.mkEnableOption "nix-search-cli: CLI for searching packages on search.nixos.org";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The nix-search-cli package to use";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
