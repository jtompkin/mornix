{
  python3Packages,
  fetchPypi,

  chntpw,
}:
python3Packages.buildPythonApplication rec {
  pname = "bt-dualboot";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pjzGvLkotQllzyrnxqDIjGlpBOvUPkWpv0eooCUrgv8=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = [ chntpw ];
}
