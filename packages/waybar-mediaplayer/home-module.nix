{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.waybar-mediaplayer;
in
{
  options.mornix.programs.waybar-mediaplayer = {
    enable = lib.mkEnableOption "media player plugin for Waybar";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The waybar-mdeiaplayer package to use";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
