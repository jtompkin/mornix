{
  lib,
  stdenv,
  fetchFromSourcehut,
  writeText,

  pkg-config,
  wayland-scanner,

  fontconfig,
  freetype,
  libxkbcommon,
  wayland,
  wayland-protocols,

  # Customization
  config,
  conf ? config.wled.conf or null,
  patches ? config.wled.patches or [ ],
  extraLibs ? config.wled.extraLibs or [ ],
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wled";
  version = "0-unstable-2026-02-26";
  _commit = "fa4fbc2f4eaa612987c98779807281b24171bf69";

  src = fetchFromSourcehut {
    owner = "~coasteen";
    repo = "wlED";
    rev = finalAttrs._commit;
    hash = "sha256-t9O77ihMBiFz5DZdy5YqEKLWJ2XZ10hwe0uyl7/g6XM=";
  };

  inherit patches;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    fontconfig
    freetype
    libxkbcommon
    wayland
  ]
  ++ extraLibs;

  configFile =
    if lib.isDerivation conf || builtins.isPath conf then
      conf
    else
      writeText "config.h" (toString conf);
  postPatch = lib.optionalString (conf != null) ''
    cp ${finalAttrs.configFile} config.h
  '';

  preBuild = ''
    substituteInPlace build.sh \
      --replace-fail \
        /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml \
        ${wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml
    patchShebangs --build build.sh
  '';
  buildPhase = ''
    runHook preBuild

    ./build.sh build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 wled $out/bin/wled

    runHook postInstall
  '';

  meta = {
    description = "Simple Wayland text editor with a bottom bar";
    homepage = "https://git.sr.ht/~coasteen/wlED";
    license = lib.licenses.gpl2;
  };
})
