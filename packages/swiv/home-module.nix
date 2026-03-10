{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.swiv;
in
{
  options.mornix.programs.swiv = {
    enable = lib.mkEnableOption "swiv: Simple wayland image viewer";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The swiv package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The swiv package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
