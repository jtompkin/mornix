{
  lib,
  ...
}:
{
  options.mornix.programs.zshPlugins = {
    enable = lib.mkEnableOption "Zsh plugins (currently unused)";
    zimfw-completion.package = lib.mkOption {
      type = lib.types.package;
    };
    zimfw-environment.package = lib.mkOption {
      type = lib.types.package;
    };
    zimfw-input.package = lib.mkOption {
      type = lib.types.package;
    };
    zimfw-termtitle.package = lib.mkOption {
      type = lib.types.package;
    };
  };
}
