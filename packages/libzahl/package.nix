{
  lib,
  stdenv,
  fetchgit,

  texliveBasic,

  buildDoc ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libzahl";
  version = "unstable";
  _commit = "2c4bb8e40512725876f3d86e4887b2dc231371ff";

  src = fetchgit {
    url = "git://git.suckless.org/libzahl";
    rev = finalAttrs._commit;
    hash = "sha256-oVPPVYsnhxDwX5MBk1X2O4sN64VcvpDRCNux2vRLghU=";
  };

  outputs = [
    "dev"
    "out"
    "man"
    "devman"
  ]
  ++ lib.optional buildDoc "doc";

  nativeBuildInputs =
    [ ]
    ++ lib.optional buildDoc (
      texliveBasic.withPackages (
        ps: with ps; [
          algorithms
          cm-super
          enumitem
          esvect
          float
          jknapltx
          mathtools
          metafont
          microtype
          minitoc
          mnsymbol
          rsfs
          shorttoc
          tipa
          wasy
          wasy-type1
          wasysym
        ]
      )
    );

  makeFlags = [
    "CC=cc"
    "PREFIX=$(out)"
  ];

  preBuild = ''
    substituteInPlace config.mk \
      --replace-fail 'CFLAGS   =' 'CFLAGS = -std=c99 -ffat-lto-objects'
    ${lib.optionalString (!buildDoc) ''
      substituteInPlace Makefile \
        --replace-fail 'all: libzahl.a $(DOC)' 'all: libzahl.a' \
        --replace-fail 'mkdir -p -- "$(DESTDIR)$(DOCPREFIX)/libzahl"' "" \
        --replace-fail 'cp -- $(DOC) "$(DESTDIR)$(DOCPREFIX)/libzahl"' ""
    ''}
  '';

  meta = {
    description = "library for arbitrary size integers, bigint";
    homepage = "https://libs.suckless.org/libzahl/";
    license = lib.licenses.isc;
  };
})
