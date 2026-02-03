{
  config,
  lib,
  pkgs,
  ...
}:
let
  programCfg = config.mornix.programs.clipboard-sync;
  serviceCfg = config.mornix.services.clipboard-sync;
in
{
  options.mornix = {
    programs.clipboard-sync = {
      enable = lib.mkEnableOption "clipboard-sync, a clipboard synchronizer";
      package = lib.mkPackageOption pkgs "clipboard-sync" { };
    };
    services.clipboard-sync.enable = lib.mkEnableOption "clipboard-sync systemd service";
  };
  config.home.packages = lib.mkIf programCfg.enable [ programCfg.package ];
  # Stolen from: https://github.com/dnut/clipboard-sync/blob/master/flake.nix
  config.systemd.user.services.clipboard-sync = lib.mkIf serviceCfg.enable {
    description = "Synchronize clipboards across all displays";
    documentation = [ "https://github.com/dnut/clipboard-sync/" ];
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    requisite = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "/usr/bin/env ${lib.getExe programCfg.package} --hide-timestamp --log-level debug";
      Restart = "on-failure";
    };
  };
}
