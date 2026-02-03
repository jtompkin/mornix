{
  fetchFromGitHub,
  libxcb,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "clipbaord-sync";
  version = "2025-09-30";
  src = fetchFromGitHub {
    owner = "dnut";
    repo = "clipboard-sync";
    rev = "138a59b8f3044dd9e7dcccd9607bbbb48c14bae6";
    hash = "sha256-pDsDzWEBaZlT9lHsBZMGm8aBJGncMxqerKwkzjEM/EI=";
  };
  cargoHash = "sha256-kc+650Lk8hueAzxZGa/deWsNAWgsXCq+rz73BCQiS9E=";
  buildInputs = [ libxcb ];
  meta = {
    description = "Synchronize the clipboard across multiple X11 and Wayland instances";
    homepage = "https://github.com/dnut/clipboard-sync";
    mainProgram = "clipboard-sync";
  };
}
