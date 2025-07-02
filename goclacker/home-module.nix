{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    mkOption
    mkBefore
    mkAfter
    types
    ;
  cfg = config.programs.goclacker;
in
{
  options = {
    programs.goclacker = {
      enable = mkEnableOption "goclacker RPN calculator";
      package = mkPackageOption pkgs "goclacker" { };
      prompt = mkOption {
        type = types.str;
        default = "";
        description = "String to set prompt configuration";
        example = "-&3t-&l- <3 ";
      };
      words = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = "Attribute set of words with names being the word name and values being the word definition";
        example = {
          sqrt = "0.5 ^";
          logb = "log swap log / -1 ^";
        };
      };
      valueWords = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = "Attribute set of value words with names being the word name and values being the word definition";
        example = {
          pi = "22 6 /";
        };
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra config to add to the configuration file";
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."goclacker/goclacker.conf" = {
      enable = !(cfg.prompt == "" && cfg.words == { } && cfg.valueWords == { } && cfg.extraConfig == "");
      text = lib.mkMerge [
        (mkBefore cfg.prompt)
        (lib.concatMapAttrsStringSep "\n" (name: def: "= ${name} ${def}") cfg.words)
        (lib.concatMapAttrsStringSep "\n" (name: def: "== ${name} ${def}") cfg.valueWords)
        (mkAfter cfg.extraConfig)
      ];
    };
  };
}
