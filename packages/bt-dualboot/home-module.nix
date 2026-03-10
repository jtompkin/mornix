{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.bt-dualboot;
in
{
  options.mornix.programs.bt-dualboot = {
    enable = lib.mkEnableOption "bt-dualboot dual boot bluetooth fix application";
    package = lib.mkPackageOption pkgs "bt-dualboot" { };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
