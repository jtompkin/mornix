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
    warnings = [
      ''
        Module mornix.programs.neuswc: SECURITY WARNING
          This module installs a setuid wrapper for the swc-launch program.
          Make sure you trust the following package before running the executable:
          ${cfg.finalPackage}
      ''
    ];
    environment.systemPackages = [ cfg.finalPackage ];
    security.wrappers.swc-launch = {
      setuid = true;
      owner = "root";
      group = "root";
      source = lib.getExe' cfg.finalPackage "swc-launch";
    };
  };
}
