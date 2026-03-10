{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.mojito;
in
{
  options.mornix.programs.mojito = {
    enable = lib.mkEnableOption "mojito: Featherweight, lime-scented (and somewhat alcoholic) bar for Wayland";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The mojito package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The mojito package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];
  };
}
