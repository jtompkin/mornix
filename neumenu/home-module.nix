{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.neumenu;
in
{
  options.mornix.programs.neumenu = {
    enable = lib.mkEnableOption "neumenu menu";
    package = lib.mkPackageOption pkgs "neumenu" { };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "neumenu package that is used in config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
