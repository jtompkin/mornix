{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.shko;
in
{
  options.mornix.programs.shko = {
    enable = lib.mkEnableOption "shko: Keyboard-oriented, floating, zomming, scrolling window manager";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The shko package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The shko package that is used in the config";
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
