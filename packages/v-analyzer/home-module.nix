{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mornix.programs.v-analyzer;
  settingsType =
    let
      inherit (lib) mkOption types;
    in
    {
      options = {
        custom_vroot = mkOption {
          description = ''
            Specifies the path to the V installation directory with `v` executable.
            If not set, the plugin will try to find it on its own.
            Basically, you don't need to set it.
          '';
          type = types.nullOr types.str;
          default = null;
        };
        custom_cache_dir = mkOption {
          description = ''
            Specifies the path where to store the cache.
            By default, it is stored in the system's cache directory.
            You can set it to `./` to store the cache in the project's directory, this is useful
            if you want to debug the analyzer.
            Basically, you don't need to set it.
          '';
          type = types.nullOr types.str;
          default = null;
        };
        enable_semantic_tokens = mkOption {
          description = ''
            Specifies whenever to enable semantic tokens or not.
            - `full` — enables all semantic tokens. In this mode analyzer resolves all symbols
               in the file to provide the most accurate highlighting.
            - `syntax` — enables only syntax tokens, such tokens highlight structural elements
               such as field names or import names.
               The fastest option, which is always enabled when the file contains more than 1000 lines.
            - `none` — disables semantic tokens.
            By default, `full` for files with less than 1000 lines, `syntax` for files with more.
          '';
          type = types.enum [
            "full"
            "syntax"
            "none"
          ];
          default = "full";
        };
        inlay_hints = mkOption {
          description = "Specifies inlay hints to show";
          type = types.submodule {
            options = {
              enable = mkOption {
                description = ''
                  Specifies whenever to enable inlay hints or not.
                  By default, they are enabled.
                '';
                type = types.bool;
                default = true;
              };
              enable_range_hints = mkOption {
                description = ''
                  Specifies whenever to show type hints for ranges or not.
                  Example:
                  ```
                  0 ≤ .. < 10
                    ^    ^
                  ```
                  or:
                  ```
                  a[0 ≤ .. < 10]
                      ^    ^
                  ```
                '';
                type = types.bool;
                default = true;
              };
              enable_type_hints = mkOption {
                description = ''
                  Specifies whenever to show type hints for variables or not.
                  Example:
                  ```
                  name : Foo := foo()
                       ^^^^^
                  ```
                '';
                type = types.bool;
                default = true;
              };
              enable_implicit_err_hints = mkOption {
                description = ''
                  Specifies whenever to show hints for implicit err variables or not.
                  Example:
                  ```
                  foo() or { err ->
                             ^^^^^^
                  }
                  ```
                '';
                type = types.bool;
                default = true;
              };
              enable_parameter_name_hints = mkOption {
                description = ''
                  Specifies whenever to show hints for function parameters in call or not.
                  Example:
                  ```
                  fn foo(a int, b int) int {}

                  foo(a: 1, b: 2)
                      ^^    ^^
                '';
                type = types.bool;
                default = true;
              };
              enable_constant_type_hints = mkOption {
                description = ''
                  Specifies whenever to show type hints for constants or not.
                  Example:
                  ```
                  const foo : int = 1
                            ^^^^^
                  ```
                '';
                type = types.bool;
                default = true;
              };
              enable_enum_field_value_hints = mkOption {
                description = ''
                  Specifies whenever to show hints for enum field values or not.
                  Example:
                  ```
                  enum Foo {
                    bar = 0
                        ^^^
                    baz = 1
                        ^^^
                  }
                  ```
                '';
                type = types.bool;
                default = true;
              };
            };
          };
        };
        code_lens = mkOption {
          description = "Specifies code lenses to show";
          type = types.submodule {
            options = {
              enable = mkOption {
                description = ''
                  Specifies whenever to enable code lenses or not.
                  By default, they are enabled.
                '';
                type = types.bool;
                default = true;
              };
              enable_run_lens = mkOption {
                description = ''
                  Specifies whenever to show code lenses for main function to run current directory or not.
                  Example:
                  ```
                  ▶ Run
                  fn main() {}
                  ```
                '';
                type = types.bool;
                default = true;
              };
              enable_inheritors_lens = mkOption {
                description = ''
                  Specifies whenever to show code lenses for interface inheritors or not.
                  Example:
                  ```
                  2 implementations
                  interface Foo {}
                  ```
                '';
                type = types.bool;
                default = true;
              };
              enable_super_interfaces_lens = mkOption {
                description = ''
                  Specifies whenever to show code lenses for structs implementing interfaces or not.
                  Example:
                  ```
                  implemented 2 interfaces
                  struct Boo {}
                  ```
                '';
                type = types.bool;
                default = true;
              };
              enable_run_tests_lens = mkOption {
                description = ''
                  Specifies whenever to show code lenses for test functions to run test or whole file or not.
                  Example:
                  ```
                  ▶ Run test | all file tests
                  fn test_foo() {}
                  ```
                  Note: "all file tests" is shown only for the first test function in the file.
                '';
                type = types.bool;
                default = true;
              };
            };
          };
        };
      };
    };
in
{
  options.mornix.programs.v-analyzer = {
    enable = lib.mkEnableOption "v-analyzer, the Vlang language server";
    package = lib.mkOption {
      description = "The v-analyzer package to use";
      type = lib.types.package;
    };
    settings = lib.mkOption {
      description = "the global v-analyzer config";
      type = lib.types.submodule settingsType;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."v-analyzer/config.toml".source =
      (pkgs.formats.toml { }).generate "v-analyzer-config.toml"
        (lib.filterAttrsRecursive (n: v: v != null) cfg.settings);
  };
}
