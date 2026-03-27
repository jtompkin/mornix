{
  lib,
  stdenv,
  fetchFromGitHub,

  autoreconfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vsearch";
  version = "2.30.6";

  src = fetchFromGitHub {
    owner = "torognes";
    repo = "vsearch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/+HJh8pDF5pVsywYu1q0oN7fYOh1KxtLxiorTbdCMv4=";
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
