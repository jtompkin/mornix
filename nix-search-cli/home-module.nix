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
