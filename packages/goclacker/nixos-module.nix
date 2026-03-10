{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.goclacker;
in
{
  options.mornix.programs.goclacker = {
    enable = lib.mkEnableOption "goclacker: Command line reverse Polish notation calculator";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The goclacker package to use";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
