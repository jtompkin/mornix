{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.wsxwm;
in
{
  options.mornix.programs.wsxwm = {
    enable = lib.mkEnableOption "wsxwm: Way Sexier Window Manager";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The wsxwm package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The wsxwm package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
