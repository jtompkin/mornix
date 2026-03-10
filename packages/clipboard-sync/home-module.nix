{
  config,
  lib,
  ...
}:
let
  programCfg = config.mornix.programs.clipboard-sync;
  serviceCfg = config.mornix.services.clipboard-sync;
in
{
  options.mornix = {
    programs.clipboard-sync = {
      enable = lib.mkEnableOption "clipboard-sync: Synchronize the clipboard across multiple X11 and Wayland instances";
      package = lib.mkOption {
        type = lib.types.package;
        description = "The clipboard-sync package to use";
      };
    };
    services.clipboard-sync.enable = lib.mkEnableOption "clipboard-sync systemd service";
  };
  config = lib.mkMerge [
    (lib.mkIf programCfg.enable {
      home.packages = [ programCfg.package ];
    })
    (lib.mkIf serviceCfg.enable {
      # Stolen from: https://github.com/dnut/clipboard-sync/blob/master/flake.nix
      systemd.user.services.clipboard-sync = {
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
    })
  ];
}
