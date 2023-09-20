{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch

# build-system
, setuptools

# runtime
, audioread
, decorator
, joblib
, lazy-loader
, matplotlib
, msgpack
, numba
, numpy
, pooch
, scikit-learn
, scipy
, soundfile
, soxr
, typing-extensions

# tests
, ffmpeg-headless
, packaging
, pytest-mpl
, pytestCheckHook
, resampy
, samplerate
}:

buildPythonPackage rec {
  pname = "librosa";
  version = "0.10.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "librosa";
    repo = "librosa";
    rev = "refs/tags/${version}";
    fetchSubmodules = true; # for test data
    hash = "sha256-zbmU87hI9A1CVcBZ/5FU8z0t6SS4jfJk9bj9kLe/EHI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-report term-missing --cov librosa --cov-report=xml " ""
  '';

  propagatedBuildInputs = [
    audioread
    decorator
    joblib
    lazy-loader
    msgpack
    numba
    numpy
    pooch
    scipy
    scikit-learn
    soundfile
    soxr
    typing-extensions
  ];

  passthru.optional-dependencies.matplotlib = [
    matplotlib
  ];

  # check that import works, this allows to capture errors like https://github.com/librosa/librosa/issues/1160
  pythonImportsCheck = [
    "librosa"
  ];

  nativeCheckInputs = [
    ffmpeg-headless
    packaging
    pytest-mpl
    pytestCheckHook
    resampy
    samplerate
  ] ++ passthru.optional-dependencies.matplotlib;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # requires network access
    "test_example"
    "test_example_info"
    "test_load_resample"
    # https://github.com/librosa/librosa/issues/1754
    "test_waveshow_mono"
    "test_waveshow_mono_trans"
    "test_waveshow_mono_zoom"
    "test_waveshow_mono_zoom_trans"
    "test_waveshow_mono_zoom_out"
    "test_waveshow_stereo"
    "test_unknown_wavaxis"
    "test_waveshow_unknown_wavaxis"
    "test_sharex_specshow_ms"
    "test_sharex_waveplot_ms"
    "test_waveshow_disconnect"
    "test_waveshow_deladaptor"
  ];

  meta = with lib; {
    description = "Python library for audio and music analysis";
    homepage = "https://github.com/librosa/librosa";
    changelog = "https://github.com/librosa/librosa/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };

}
