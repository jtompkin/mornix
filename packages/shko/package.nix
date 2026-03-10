{
  lib,
  stdenv,
  fetchFromSourcehut,
  writeText,

  zig,

  libdrm,
  libinput,
  libxcb-wm,
  libxkbcommon,
  neuswc,
  neuwld,
  pixman,
  wayland,

  # Customization
  config,
  conf ? config.shko.conf or null,
  patches ? config.shko.patches or [ ],
  extraLibs ? config.shko.extraLibs or [ ],
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shko";
  version = "2026-03-07";
  _commit = "a21d5b6a76dcf161f1b374b32a93a7e4c1439212";

  src = fetchFromSourcehut {
    owner = "~chld";
    repo = "shko";
    rev = finalAttrs._commit;
    hash = "sha256-PLj1TqZkhaSYgbtWwnfjGjF4ZtDAmkDxUadeEReGwf0=";
  };

  inherit patches;

  nativeBuildInputs = [
    zig
  ];
  buildInputs = [
    libdrm
    libinput
    libxcb-wm
    libxkbcommon
    neuswc
    neuwld
    pixman
    wayland
  ]
  ++ extraLibs;

  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontUseZigInstall = true;

  configFile =
    if lib.isDerivation conf || builtins.isPath conf then
      conf
    else
      writeText "config.h" (toString conf);
  postPatch = lib.optionalString (conf != null) ''
    cp ${finalAttrs.configFile} config.zig
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 shko $out/bin/shko

    runHook postInstall
  '';

  meta = {
    description = "Keyboard-oriented, floating, zomming, scrolling window manager";
    homepage = "https://git.sr.ht/~chld/shko";
    license = lib.licenses.unlicense;
    mainProgram = "shko";
  };
})
