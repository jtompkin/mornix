{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.swiv;
in
{
  options.mornix.programs.swiv = {
    enable = lib.mkEnableOption "swiv image viewer";
    package = lib.mkPackageOption pkgs "swiv" { };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "swiv package that is used in config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
