{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.hevel;
in
{
  options.mornix.programs.hevel = {
    enable = lib.mkEnableOption "hevel";
    package = lib.mkPackageOption pkgs "hevel" { };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "hevel package that is used in config";
    };
  };
  config = lib.mkIf cfg.enable {
    warnings = lib.mkIf (!config.mornix.programs.neuswc.enable or true) [
      ''
        You have enabled hevel but not neuswc.
        The neuswc module is required for the setuid executable swc-launch
      ''
    ];
    environment.systemPackages = [ cfg.finalPackage ];
  };
}
