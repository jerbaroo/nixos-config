{ pkgs, ... }:

pkgs.python3Packages.buildPythonApplication {
  pname = "ghdashboard";
  version = "1.0.0";
  src = ./.;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  propagatedBuildInputs = with pkgs.python3Packages; [ flask requests ];
  format = "other";
  installPhase = ''
    mkdir -p $out/bin $out/share/app
    cp server.py index.html query.graphql $out/share/app/
    makeWrapper ${pkgs.python3}/bin/python $out/bin/ghdashboard \
      --add-flags "$out/share/app/server.py" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --run "cd $out/share/app"
  '';
}
