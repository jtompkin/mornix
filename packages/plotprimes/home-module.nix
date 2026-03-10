{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.plotprimes;
in
{
  options.mornix.programs.plotprimes = {
    enable = lib.mkEnableOption "plotprimes, a tool to plot primes in a polar coordinate system";
    package = lib.mkPackageOption pkgs "plotprimes" { };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
