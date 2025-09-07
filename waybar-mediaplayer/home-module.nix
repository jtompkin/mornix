{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkPackageOption;
  cfg = config.programs.waybar-mediaplayer;
in
{
  options = {
    programs.waybar-mediaplayer = {
      enable = mkEnableOption "media player plugin for Waybar";
      package = mkPackageOption pkgs "waybar-mediaplayer" { };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
