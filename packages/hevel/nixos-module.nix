{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.hevel;
in
{
  options.mornix.programs.hevel = {
    enable = lib.mkEnableOption "hevel: Scrollable, floating window manager for Wayland";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The hevel package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The hevel package that is used in the config";
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
