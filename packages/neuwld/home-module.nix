{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.neuwld;
in
{
  options.mornix.programs.neuwld = {
    enable = lib.mkEnableOption "neuwld: Drawing library that targets Wayland";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The neuwld package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The neuwld package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
