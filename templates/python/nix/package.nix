{
  lib,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  name = "project_name";
  version = "0.0.1";
  pyproject = true;
  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.union ../src ../pyproject.toml;
  };
  build-system = [ python3Packages.setuptools ];
  dependencies = with python3Packages; [
    numpy
  ];
}
