{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.msedit;
in
{
  options.mornix.programs.msedit = {
    enable = lib.mkEnableOption "msedit, a simple editor for simple needs";
    package = lib.mkPackageOption pkgs "msedit" { };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
