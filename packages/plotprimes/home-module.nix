{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.plotprimes;
in
{
  options.mornix.programs.plotprimes = {
    enable = lib.mkEnableOption "plotprimes: Make nice polar plots of prime numbers";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The plotprimes package to use";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
