{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.neuswc;
in
{
  options.mornix.programs.neuswc = {
    enable = lib.mkEnableOption "neuswc";
    package = lib.mkPackageOption pkgs "neuswc" { };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "neuswc package that is used for config";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];
    security.wrappers.swc-launch = {
      setuid = true;
      owner = "root";
      group = "root";
      source = lib.getExe' cfg.finalPackage "swc-launch";
    };
  };
}
