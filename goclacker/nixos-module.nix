{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkPackageOption;
  cfg = config.programs.goclacker;
in
{
  options = {
    programs.goclacker = {
      enable = mkEnableOption "goclacker RPN calculator";
      package = mkPackageOption pkgs "goclacker" { };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
