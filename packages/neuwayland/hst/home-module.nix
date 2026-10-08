{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.hst;
in
{
  options.mornix.programs.hst = {
    enable = lib.mkEnableOption "hst: Fork of st-wl using neuwld";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The hst package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The hst package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
