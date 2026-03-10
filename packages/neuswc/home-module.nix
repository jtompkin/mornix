{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.neuswc;
in
{
  options.mornix.programs.neuswc = {
    enable = lib.mkEnableOption "neuswc: Fork of swc with more features";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The neuswc package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The neuswc package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
