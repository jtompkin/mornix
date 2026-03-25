{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,

  makeWrapper,
  versionCheckHook,

  boost188,
  gsl,
  hdf5,
  readline,
  zlib,

  sratoolkit,
  vsearch,

  withBoost ? true,
  withGsl ? true,
  withHdf5 ? true,
  withReadline ? true,
  withVsearch ? true,
  # sratoolkit in Nixpkgs is marked as unfree, so disabled by default
  withSratoolkit ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mothur";
  version = "1.48.5";

  src = fetchFromGitHub {
    owner = "mothur";
    repo = "mothur";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ec0YBifDoota8nzMxaSnXgBRWlBVQvCH6lQUG/bzZPg=";
  };

  patches = [
    # Fix not including source/ directory
    (fetchurl {
      url = "https://github.com/mothur/mothur/commit/cd82e4538d26f3913f0eb5553f34165dab55701f.diff";
      hash = "sha256-+AwZ/wNgFeBwm6bH/06rGwksHuUWeOv0ZpaBPwcUPz8=";
    })
    ./include_memory.diff
  ];

  enableParallelBuilding = true;
  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  nativeBuildInputs = [ makeWrapper ];
  buildInputs =
    [ ]
    ++ lib.optionals withBoost [
      boost188
      zlib
    ]
    ++ lib.optional withGsl gsl
    ++ lib.optional withHdf5 hdf5
    ++ lib.optional withReadline readline;

  makeFlags = [
    "INSTALL_DIR=$(out)/bin"
  ]
  ++ lib.optional withBoost "USEBOOST=yes"
  ++ lib.optional withGsl "USEGSL=yes"
  ++ lib.optional withHdf5 "USEHDF5=yes"
  ++ lib.optional withReadline "USEREADLINE=yes";

  postInstall = ''
    install -D -m 755 uchime $out/bin/uchime
    wrapProgram $out/bin/mothur \
      --prefix PATH : ${
        lib.makeBinPath ([ ] ++ lib.optional withSratoolkit sratoolkit ++ lib.optional withVsearch vsearch)
      }
  '';

  meta = {
    description = "Microbial bioinformatics";
    homepage = "https://mothur.org/";
    license = lib.licenses.gpl3;
    mainProgram = "mothur";
  };
})
