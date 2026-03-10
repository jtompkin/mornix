{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.hst;
in
{
  options.mornix.programs.hst = {
    enable = lib.mkEnableOption "hst fork of st-wl";
    package = lib.mkPackageOption pkgs "hst" { };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "hst package that is used in config";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];
  };
}
