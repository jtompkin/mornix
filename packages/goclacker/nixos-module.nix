{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.goclacker;
in
{
  options.mornix.programs.goclacker = {
    enable = lib.mkEnableOption "goclacker RPN calculator";
    package = lib.mkPackageOption pkgs "goclacker" { };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
