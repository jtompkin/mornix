{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.tRNAscan-se;
in
{
  options.mornix.programs.tRNAscan-se = {
    enable = lib.mkEnableOption "tRNAscan-se";
    package = lib.mkPackageOption pkgs "tRNAscan-se" { };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
