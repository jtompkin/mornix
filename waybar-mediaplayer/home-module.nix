{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.waybar-mediaplayer;
in
{
  options.mornix.programs.waybar-mediaplayer = {
    enable = lib.mkEnableOption "media player plugin for Waybar";
    package = lib.mkPackageOption pkgs "waybar-mediaplayer" { };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
