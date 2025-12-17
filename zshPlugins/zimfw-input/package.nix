{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "zimfw-input";
  version = "2025-12-15";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "input";
    rev = "da6b1cccac5e56104088acc2d66e181f3317192a";
    hash = "sha256-QWyQpOxU3+P2+EGTkzt9HdEwhVnBa3yPwv7JA2o5YIQ=";
  };
  installPhase = ''
    mkdir -p $out
    cp init.zsh $out/zimfw-input.plugin.zsh
  '';
  meta = {
    description = " Applies correct bindkeys for input events in zsh";
    homepage = "https://github.com/zimfw/input";
    license = lib.licenses.mit;
  };
}
