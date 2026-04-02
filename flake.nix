{
  description = "A collection of custom Nix packages/modules/overlays/treats";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: lib.genAttrs allSystems (system: f system nixpkgs.legacyPackages.${system});
      removeRecurseHint = attrs: removeAttrs attrs [ "recurseForDerivations" ];
      getPackageDrv =
        pkgs: pkgSet: pkgName: pkgArgs:
        pkgs.callPackage ./packages/${pkgSet}/${pkgName}/package.nix pkgArgs;
      getModule =
        type: pkgSet: pkgName:
        { lib, pkgs, ... }:
        {
          imports = [ ./packages/${pkgSet}/${pkgName}/${type}-module.nix ];
          config.mornix.programs.${pkgName}.package =
            lib.mkOptionDefault
              self.packages.${pkgs.stdenv.hostPlatform.system}.${pkgName};
        };
      nixosModules =
        lib.genAttrs [
          "freeway"
          "goclacker"
          "hevel"
          "hst"
          "mojito"
          "neumenu"
          "neuswc"
          "neuwld"
          "shko"
          "swall"
          "swclock"
          "swiv"
          "wsxwm"
        ] (getModule "nixos" "")
        // {
          allPackages =
            { lib, pkgs, ... }:
            {
              options.mornix.allPrograms = lib.mkOption {
                type = lib.types.attrsOf lib.types.package;
                readOnly = true;
                default = self.packages.${pkgs.stdenv.hostPlatform.system};
              };
            };
        };
      homeModules =
        lib.genAttrs [
          "bt-dualboot"
          "clipboard-sync"
          "freeway"
          "goclacker"
          "hevel"
          "hst"
          "mojito"
          "neumenu"
          "neuswc"
          "neuwld"
          "nix-search-cli"
          "plotprimes"
          "shko"
          "swall"
          "swclock"
          "swiv"
          "tRNAscan-se"
          "waybar-mediaplayer"
          "wsxwm"
        ] (getModule "home" "")
        // {
          vimPlugins =
            { lib, pkgs, ... }:
            {
              imports = [ ./packages/vimPlugins/home-module.nix ];
              config.mornix.programs.vimPlugins = lib.mapAttrs (_: package: {
                package = lib.mkDefault package;
              }) (removeRecurseHint self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.vimPlugins);
            };
          zshPlugins =
            { lib, pkgs, ... }:
            {
              imports = [ ./packages/zshPlugins/home-module.nix ];
              config.mornix.programs.zshPlugins = lib.mapAttrs (_: package: {
                package = lib.mkDefault package;
              }) (removeRecurseHint self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.zshPlugins);
            };
          allPackages =
            { lib, pkgs, ... }:
            {
              options.mornix.allPackages = lib.mkOption {
                type = lib.types.attrsOf lib.types.package;
                readOnly = true;
                default = self.packages.${pkgs.stdenv.hostPlatform.system};
              };
            };
        };
    in
    {
      # Package sets go in here. They will be merged into `packages` at the top level.
      # Do not use nested package sets.
      legacyPackages = forAllSystems (
        system: pkgs: {
          vimPlugins = lib.recurseIntoAttrs (
            lib.mapAttrs (getPackageDrv pkgs "vimPlugins") {
              cmp-mini-snippets = { };
            }
          );
          zshPlugins = lib.recurseIntoAttrs (
            lib.mapAttrs (getPackageDrv pkgs "zshPlugins") {
              zimfw-completion = { };
              zimfw-termtitle = { };
              zimfw-environment = { };
              zimfw-input = { };
            }
          );
        }
      );
      packages = forAllSystems (
        system: pkgs:
        removeRecurseHint (lib.mergeAttrsList (lib.attrValues self.legacyPackages.${system}))
        // lib.mapAttrs (getPackageDrv pkgs "") {
          bt-dualboot = { };
          clipboard-sync = { };
          freeway = { };
          gnubg = { };
          goclacker = { };
          hack = { inherit (self.packages.${system}) neuwld; };
          hevel = { inherit (self.packages.${system}) neuswc neuwld; };
          hst = { inherit (self.packages.${system}) neuwld; };
          infernal = { };
          klatka = { inherit (self.packages.${system}) neuwld neuswc; };
          mojito = { inherit (self.packages.${system}) neuwld neuswc; };
          mothur = { inherit (self.packages.${system}) vsearch; };
          ncbi-datasets-cli = { };
          neumenu = { inherit (self.packages.${system}) neuwld neuswc; };
          neuswc = { inherit (self.packages.${system}) neuwld; };
          neuwld = { };
          nix-search-cli = { };
          plotprimes = { };
          seven-kingdoms = { };
          shko = { inherit (self.packages.${system}) neuwld neuswc; };
          swall = { };
          swclock = { inherit (self.packages.${system}) neuwld; };
          swiv = { inherit (self.packages.${system}) neuwld; };
          tRNAscan-se = { inherit (self.packages.${system}) infernal; };
          vsearch = { };
          waybar-mediaplayer = { };
          wled = { };
          wsxwm = { inherit (self.packages.${system}) neuwld neuswc; };
        }
      );
      nixosModules = nixosModules // {
        default = {
          imports = lib.attrValues nixosModules;
        };
      };
      homeModules = homeModules // {
        default = {
          imports = lib.attrValues homeModules;
        };
      };
      templates = {
        standard = {
          path = ./templates/standard;
          description = "Bog standard flake";
        };
        python = {
          path = ./templates/python;
          description = "Basic Python project";
        };
        default = self.templates.standard;
      };
      overlays = {
        all = final: prev: self.packages.${prev.stdenv.hostPlatform.system};
        default = self.overlays.all;
      };
      formatter = forAllSystems (system: pkgs: pkgs.nixfmt-tree);
      checks = forAllSystems (system: pkgs: self.packages.${system});
    };
}
