{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-prompt";
  version = "1.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sbrunner";
    repo = "sphinx-prompt";
    rev = "refs/tags/${version}";
    hash = "sha256-jgPD5DBpcj+/FqCI+lkycyYqQHnE8DQLrGLmr5iYBqE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"poetry-plugin-tweak-dependencies-version", ' "" \
      --replace 'include = "sphinx-prompt' 'include = "sphinx_prompt'
  '';

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [ sphinx ];

  meta = with lib; {
    description = "A sphinx extension for creating unselectable prompt";
    homepage = "https://github.com/sbrunner/sphinx-prompt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
