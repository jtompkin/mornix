{
  lib,
  stdenv,
  fetchFromSourcehut,
  writeText,

  pkg-config,
  wayland-scanner,

  fontconfig,
  neuwld,
  pixman,
  wayland,
  wayland-protocols,

  # Customization
  config,
  conf ? config.swclock.conf or null,
  patches ? config.swclock.patches or [ ],
  extraLibs ? config.hack.extraLibs or [ ],
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "swclock";
  version = "2026-02-08";
  _commit = "6b235cc8034b4da78cd322c382aee9d870175d81";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "swclock";
    rev = finalAttrs._commit;
    hash = "sha256-/KKQxzC7Wp6CFjBz37trBrYh9kew5bN8JjdBD8+Hbec=";
  };

  inherit patches;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    fontconfig
    neuwld
    pixman
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

  makeFlags = [
    "XDG_SHELL_XML=${wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml"
  ];

  installPhase = ''
    runHook preInstall

    install -D -m 755 swclock $out/bin/swclock

    runHook postInstall
  '';

  meta = {
    description = "Clock program for Wayland";
    homepage = "https://git.sr.ht/~shrub900/swclock";
    mainProgram = "swclock";
  };
})
