{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.swall;
in
{
  options.mornix.programs.swall = {
    enable = lib.mkEnableOption "swall wallpaper setter";
    package = lib.mkPackageOption pkgs "swall" { };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "swall package that is used in config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
