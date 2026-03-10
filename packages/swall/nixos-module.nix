{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.swall;
in
{
  options.mornix.programs.swall = {
    enable = lib.mkEnableOption "swall: Wallpaper setter for neuswc";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The swall package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The swall package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];
  };
}
