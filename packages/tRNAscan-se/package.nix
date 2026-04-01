{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,

  perl,
  infernal,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tRNAscan-se";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "UCSC-LoweLab";
    repo = "tRNAscan-SE";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vQ17yLQPn4iZVY4jAD8W2J/CNOkP80T4NwcVyu+5CZc=";
  };

  nativeBuildInputs = [
    perl
    makeWrapper
  ];

  preConfigure = ''
    makeFlagsArray+=(
      CFLAGS="-O3 -std=c99"
    )
    substituteInPlace tRNAscan-SE.conf.src \
      --replace-fail 'infernal_dir: {bin_dir}' 'infernal_dir: ${infernal}/bin'
  '';

  postInstall = ''
    wrapProgram $out/bin/tRNAscan-SE \
      --prefix PATH : ${lib.makeBinPath [ perl ]}
  '';

  meta = {
    description = "Program for detection of tRNA genes";
    homepage = "https://github.com/UCSC-LoweLab/tRNAscan-SE";
    mainProgram = "tRNAscan-SE";
    license = lib.licenses.gpl3Plus;
  };
})
