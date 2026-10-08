{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.freeway;
in
{
  options.mornix.programs.freeway = {
    enable = lib.mkEnableOption "freeway: Simpler libwayland";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The freeway package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The freeway package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];
  };
}
