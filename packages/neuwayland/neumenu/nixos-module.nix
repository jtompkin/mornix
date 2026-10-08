{
  config,
  lib,
  ...
}:
let
  cfg = config.mornix.programs.neumenu;
in
{
  options.mornix.programs.neumenu = {
    enable = lib.mkEnableOption "neumenu: Efficient dynamic menu for wayland";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The neumenu package to use";
    };
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package;
      description = "The neumenu package that is used in the config";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];
  };
}
