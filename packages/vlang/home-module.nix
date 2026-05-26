{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.vlang;
in
{
  options.mornix.programs.vlang = {
    enable = lib.mkEnableOption "vlang unstable";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The vlang package to use";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
