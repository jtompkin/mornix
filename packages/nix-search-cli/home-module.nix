/*
  This file is licensed under the terms of the LICENSE file found in the root directory
  of this repository (https://github.com/jtompkin/mornix), not the LICENSE file found in
  this directory
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.nix-search-cli;
in
{
  options.mornix.programs.nix-search-cli = {
    enable = lib.mkEnableOption "nix-search-cli, a CLI for searching packages on search.nixos.org";
    package = lib.mkPackageOption pkgs "nix-search-cli" { };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
