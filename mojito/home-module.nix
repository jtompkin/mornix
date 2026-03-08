{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.mojito;
in
{
  options.mornix.programs.mojito = {
    enable = lib.mkEnableOption "mojito Wayland bar";
    package = lib.mkPackageOption pkgs "mojito" { };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "mojito package that is used in config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
