{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.wren-lsp;
in
{
  options.mornix.programs.wren-lsp = {
    enable = lib.mkEnableOption "wren-lsp: LSP server for the wren programming language";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The wren-lsp package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The wren-lsp package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
  };
}
