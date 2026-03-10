{
  lib,
  ...
}:
{
  options.mornix.programs.vimPlugins = {
    enable = lib.mkEnableOption "vimPlugins (currently unused)";
    cmp-mini-snippets.package = lib.mkOption {
      type = lib.types.package;
    };
  };
}
