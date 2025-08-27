{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkPackageOption;
  cfg = config.programs.spotify-player-git;
in
{
  options = {
    programs.spotify-player-git = {
      enable = mkEnableOption "master branch of spotify-player";
      package = mkPackageOption pkgs "spotify-player-git" { };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
