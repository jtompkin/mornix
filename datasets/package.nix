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
fetchurl rec {
  pname = "datasets";
  version = "v2";
  executable = true;
  url = "https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/${version}/${systemMap.${stdenv.system}}/${pname}";
  hash = "sha256-C1n0jNQqRj7/UpTBe5ruHieaUtrNyxVav3WPKeO0rHk=";
}
