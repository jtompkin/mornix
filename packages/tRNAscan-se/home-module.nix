{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.tRNAscan-se;
in
{
  options.mornix.programs.tRNAscan-se = {
    enable = lib.mkEnableOption "tRNAscan-se: Program for detection of tRNA genes";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The tRNAscan-se package to use";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
