{
  lib,
  fetchFromGitHub,
  fetchzip,

  vlang,
}:
let
  vc = vlang.VC.overrideAttrs {
    version = "0-unstable-2026-05-26";
    src = vlang.VC.src.overrideAttrs {
      rev = "4dd90ed23dcce68ed8f1d719c3f66f433f6c2e69";
      hash = "sha256-qK74upahhnwgEgW+J9hKLehOM/CxNelFvYM0saoNPUw=";
    };
  };
in
vlang.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "0-unstable-2026-05-26";
    src = vlang.src.overrideAttrs {
      rev = "6fef27f37132d22f27f45962e61479d8195e7f13";
      hash = "sha256-gISt1XmK+qDeQARXr1VMYlKyNe7yteY40ye53Z6hFgI=";
    };
    markdown = fetchFromGitHub {
      owner = "vlang";
      repo = "markdown";
      rev = "ef2f1018c37c1db6e379331b3cd841331b6a6fd2";
      hash = "sha256-drhDQYm7yiL+EDyslkTb0MGA9NQRrDLVg3IElwXAIIY=";
    };
    sqlite-amalgamation = fetchzip {
      url = "https://sqlite.org/2026/sqlite-amalgamation-3530100.zip";
      hash = "sha256-MlGJVJYziciNZoWkMbtGKGt+cYim2tgx3/kT1Nn1ibY=";
    };

    env.VC = vc;

    preBuild = previousAttrs.preBuild + ''
      mkdir -p ./thirdparty/sqlite
      cp -v ${finalAttrs.sqlite-amalgamation}/sqlite3.{c,h} ./thirdparty/sqlite
    '';

    installPhase = lib.pipe previousAttrs.installPhase [
      (lib.splitString "\n")
      (map (builtins.split "^(ln -sf /nix/store/.*-source)"))
      (map (
        builtins.foldl' (
          acc: s: acc + (if builtins.isList s then "ln -sf ${finalAttrs.markdown}" else s)
        ) ""
      ))
      (lib.join "\n")
    ];
  }
)
