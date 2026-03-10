{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonPackage (finalAttrs: {
  pname = "plotprimes";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "jtompkin";
    repo = "plot-primes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AcWdmzk+jxaHkhMP6BZTW/Mf/TjC7HzaUie2IDpgikg=";
  };
  pyproject = true;
  build-system = [ python3Packages.setuptools ];
  nativeCheckInputs = [ python3Packages.pytestCheckHook ];
  dependencies = [ python3Packages.matplotlib ];
  meta = {
    description = "Make nice polar plots of prime numbers";
    homepage = "https://github.com/jtompkin/plot-primes";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    mainProgram = "plotprimes";
  };
})
