{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkPackageOption;
  cfg = config.programs.msedit;
in
{
  options = {
    programs.msedit = {
      enable = mkEnableOption "msedit, a simple editor for simple needs";
      package = mkPackageOption pkgs "msedit" { };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
