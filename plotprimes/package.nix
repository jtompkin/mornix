{
  python3Packages,
  fetchFromGitHub,
}:
let
  version = "1.0.1";
in
python3Packages.buildPythonPackage {
  pname = "plotprimes";
  version = version;
  pyproject = true;
  src = fetchFromGitHub {
    owner = "jtompkin";
    repo = "plot-primes";
    rev = "v${version}";
    hash = "sha256-AcWdmzk+jxaHkhMP6BZTW/Mf/TjC7HzaUie2IDpgikg=";
  };
  build-system = [ python3Packages.setuptools ];
  nativeCheckInputs = [ python3Packages.pytestCheckHook ];
  dependencies = [ python3Packages.matplotlib ];
  meta = {
    mainProgram = "plotprimes";
  };
}
