{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.bt-dualboot;
in
{
  options.mornix.programs.bt-dualboot = {
    enable = lib.mkEnableOption "bt-dualboot: Sync Bluetooth for dualboot Linux and Windows";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The bt-dualboot package to use";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
