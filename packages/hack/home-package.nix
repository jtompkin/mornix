{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.hack;
in
{
  options.mornix.programs.hack = {
    enable = lib.mkEnableOption "hack: Acme text editor for Wayland";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The hack package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The hack package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
