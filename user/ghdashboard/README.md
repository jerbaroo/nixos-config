``` nix
# Import the server, that will serve the dashboard.
ghdashboard = import "${builtins.fetchTarball {
  sha256 = "sha256:1xfab6mf63lvb64rgvpvknmnn7j0c19bc0f5xsdmhq9093x11f0f";
  url = "https://github.com/jerbaroo/nixos-config/archive/main.tar.gz";
}}/user/ghdashboard/default.nix" { inherit pkgs; };
# For convenience, create a wrapper script that will provide the port to run on and
# the path to an executable that will return a GitHub token ("classic" with "read"
# permissions).
ghdashboardwithargs = pkgs.writeShellScriptBin "ghdashboardwithargs" "${ghdashboard}/bin/ghdashboard ${toString(ghdashboardPort)} /home/${username}/.config/read-gh-token.sh";
# Run server at login (where to do this depends on your DE/WM), but add something like:
"${ghdashboardwithargs}/bin/ghdashboardwithargs"
# Then visit localhost:port to see the dashboard. Use optional query parameter 'org' to
# filter results to a specific organisation.
```
