{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          (python3.withPackages (pp: [
            pp.pypresence
            (callPackage ({ lib, buildPythonPackage, cython, fetchFromGitHub, }:
              buildPythonPackage rec {
                pname = "py-slippi";
                version = "1.6.2";
                format = "setuptools";

                src = fetchPypi {
                  inherit pname version;
                  hash = "sha256-c6tJI/mPlBGIYTk5ObIQ1CUTq73HouQ2quMZVWG8FFg=";
                };

                env.JQPY_USE_SYSTEM_LIBS = 1;
                nativeBuildInputs = [ cython ];
                buildInputs = [ jq oniguruma ];
                nativeCheckInputs = [ pytestCheckHook ];
            }))
          ]))
        ];
      };
    }
  );
}

