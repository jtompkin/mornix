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
  version = "0-unstable-2026-03-27";
  _commit = "d64d3adc4fb95e814ca764ec2b6894d6529f77f8";

  src = fetchFromSourcehut {
    owner = "~chld";
    repo = "shko";
    rev = finalAttrs._commit;
    hash = "sha256-otk+nx5oPkWUsB95iWmKcgjWvj4PMrLJPTLmLRC6KF4=";
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
