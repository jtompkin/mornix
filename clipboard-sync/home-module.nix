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
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Unit = {
      Description = "Synchronize cliboards across all displays";
      Documentation = [ "https://github.com/dnut/clipboard-sync" ];
      Requisite = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "/usr/bin/env ${lib.getExe programCfg.package} --hide-timestamp --log-level debug";
      Restart = "on-failure";
    };
  };
}
