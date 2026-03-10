{
  lib,
  pkgs,
  ...
}:
{
  options.mornix.programs.zshPlugins = {
    enable = lib.mkEnableOption "Zsh plugins (currently unused)";
    zimfw-completion.package = lib.mkPackageOption pkgs "zimfw-completion" {
      default = [
        "zshPlugins"
        "zimfw-completion"
      ];
    };
    zimfw-environment.package = lib.mkPackageOption pkgs "zimfw-environment" {
      default = [
        "zshPlugins"
        "zimfw-environment"
      ];
    };
    zimfw-input.package = lib.mkPackageOption pkgs "zimfw-input" {
      default = [
        "zshPlugins"
        "zimfw-input"
      ];
    };
    zimfw-termtitle.package = lib.mkPackageOption pkgs "zimfw-termtitle" {
      default = [
        "zshPlugins"
        "zimfw-termtitle"
      ];
    };
  };
}
