{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.shko;
in
{
  options.mornix.programs.shko = {
    enable = lib.mkEnableOption "shko";
    package = lib.mkPackageOption pkgs "shko" { };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "shko package that is used in config";
    };
  };
  config = lib.mkIf cfg.enable {
    warnings = lib.mkIf (!config.mornix.programs.neuswc.enable or true) [
      ''
        You have enabled shko but not neuswc.
        The neuswc module is required for the setuid executable swc-launch
      ''
    ];
    environment.systemPackages = [ cfg.finalPackage ];
  };
}
