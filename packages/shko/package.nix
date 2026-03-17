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
  version = "0-unstable-2026-03-16";
  _commit = "916a997a4a83d58d1628370f4a6237973db8042e";

  src = fetchFromSourcehut {
    owner = "~chld";
    repo = "shko";
    rev = finalAttrs._commit;
    hash = "sha256-+jNlmGoKe58SKVY85UYF1s2fnMuPvE62wC+O3aAT4Gw=";
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

  configFile =
    if lib.isDerivation conf || builtins.isPath conf then
      conf
    else
      writeText "config.zig" (toString conf);
  postPatch = lib.optionalString (conf != null) ''
    cp ${finalAttrs.configFile} config.zig
  '';

  meta = {
    description = "Keyboard-oriented, floating, zomming, scrolling window manager";
    homepage = "https://git.sr.ht/~chld/shko";
    license = lib.licenses.unlicense;
    mainProgram = "shko";
  };
})
