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
    home.packages = [ cfg.finalPackage ];
  };
}
