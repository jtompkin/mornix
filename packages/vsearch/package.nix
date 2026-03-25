{
  lib,
  stdenv,
  fetchFromGitHub,

  autoreconfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vsearch";
  version = "2.30.5";

  src = fetchFromGitHub {
    owner = "torognes";
    repo = "vsearch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4ktfX8ynUc7/Xc3OVv32Q+GcmCExsYcr5IZmvpmGngU=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    description = "Versatile tool for microbiome analysis";
    homepage = "https://github.com/torognes/vsearch";
    license = [
      lib.licenses.gpl3Plus
      lib.licenses.bsd2
    ];
  };
})
