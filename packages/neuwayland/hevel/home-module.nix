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
    home.packages = [ cfg.finalPackage ];
  };
}
