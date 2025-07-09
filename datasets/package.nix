{
  stdenv,
  fetchurl,
}:
let
  systemMap = {
    "x86_64-linux" = "linux-amd64";
    "aarch64-linux" = "linux-arm64";
    "x86_64-darwin" = "mac";
    "aarch64-darwin" = "mac";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "datasets";
  version = "v2";
  src = fetchurl {
    url = "https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/${finalAttrs.version}/${systemMap.${stdenv.system}}/${finalAttrs.pname}";
    hash = "sha256-C1n0jNQqRj7/UpTBe5ruHieaUtrNyxVav3WPKeO0rHk=";
    executable = true;
  };
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/${finalAttrs.pname}
  '';
  meta = {
    mainProgram = finalAttrs.pname;
  };
})
