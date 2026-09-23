{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.tree-sitter-wren;
in
{
  options.mornix.programs.tree-sitter-wren = {
    enable = lib.mkEnableOption "tree-sitter-wren: tree-sitter grammar and parser for wren";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The tree-sitter-wren package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The tree-sitter-wren package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
