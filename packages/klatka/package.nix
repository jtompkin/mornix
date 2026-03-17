{
  stdenv,
  fetchFromSourcehut,

  fontconfig,
  libdrm,
  libinput,
  libxcb-wm,
  libxkbcommon,
  neuswc,
  neuwld,
  pixman,
  pkg-config,
  wayland,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "klatka";
  version = "0-unstable-2026-03-15";
  _commit = "e27ba5dfa8c51b403b900f2e08b9524ded041018";

  src = fetchFromSourcehut {
    owner = "~dlm";
    repo = "klatka";
    rev = finalAttrs._commit;
    hash = "sha256-z2sd4cSByv5rCyL8nBjEP+M9+axJiB+81k2XCfE2cbs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    fontconfig
    libdrm
    libinput
    libxcb-wm
    libxkbcommon
    neuswc
    neuwld
    pixman
    wayland
  ];

  installPhase = ''
    runHook preInstall

    install -D -m 755 klatka $out/bin/klatka

    runHook postInstall
  '';

  meta = {
    description = "Kiosk-style compositor";
    homepage = "https://git.sr.ht/~dlm/klatka";
  };
})
