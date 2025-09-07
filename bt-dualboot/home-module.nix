{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkPackageOption;
  cfg = config.programs.bt-dualboot;
in
{
  options = {
    programs.bt-dualboot = {
      enable = mkEnableOption "bt-dualboot dual boot bluetooth fix application";
      package = mkPackageOption pkgs "bt-dualboot" { };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
