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
  version = "0-unstable-2026-04-02";
  _commit = "42f96e9d92e75a48675f6b411f83f6fdc5e69b93";

  src = fetchFromSourcehut {
    owner = "~chld";
    repo = "shko";
    rev = finalAttrs._commit;
    hash = "sha256-6G6ZwAcbFIN8kqsKbnrk9nL/XeJIWOi7ZbJoTZrg46U=";
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

  preBuild = ''
    substituteInPlace config.zig \
      --replace-fail 'dev/evdev/input.h' 'linux/input.h'
    substituteInPlace shko.zig \
      --replace-fail 'dev/evdev/input.h' 'linux/input.h'
  '';

  meta = {
    description = "Keyboard-oriented, floating, zomming, scrolling window manager";
    homepage = "https://git.sr.ht/~chld/shko";
    license = lib.licenses.unlicense;
    mainProgram = "shko";
  };
})
