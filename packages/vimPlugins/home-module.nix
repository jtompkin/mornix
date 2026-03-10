{
  lib,
  pkgs,
  ...
}:
{
  options.mornix.programs.vimPlugins = {
    enable = lib.mkEnableOption "vimPlugins (currently unused)";
    cmp-mini-snippets.package = lib.mkPackageOption pkgs "cmp-mini-snippets" {
      default = [
        "vimPlugins"
        "cmp-mini-snippets"
      ];
    };
  };
}
