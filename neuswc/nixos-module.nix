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
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    security.wrappers.neuswc = {
      setuid = true;
      owner = "root";
      group = "root";
      program = "swc-launch";
      source = lib.getExe' cfg.package "swc-launch";
    };
  };
}
