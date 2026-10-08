{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.swclock;
in
{
  options.mornix.programs.swclock = {
    enable = lib.mkEnableOption "swclock: Clock program for Wayland";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The swclock package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The swclock package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
