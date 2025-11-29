``` nix
# Import the server that will serve the dashboard with:
ghdashboard = import "${builtins.fetchTarball {
  sha256 = "sha256:19j09k8n0dljn38l34b3izn2amq4dkszcak8kqx1wb9hfc2ld577";
  url = "https://github.com/jerbaroo/nixos-config/archive/main.tar.gz";
}}/user/ghdashboard/default.nix" { inherit pkgs; };
# To run the server you need to provide a GitHub access token (classic) with "repo"
# permissions via the GITHUB_TOKEN environment variable, and also choose a port to run
# on. You could write a little wrapper for this:
ghdashboardwithtoken = pkgs.writeShellScriptBin
  "ghdashboardwithtoken"
  "GITHUB_TOKEN=$(cat /home/${username}/.config/.githubtoken) ${ghdashboard}/bin/ghdashboard ${port}"
# Run at login (how to do this depends on your DE/WM), but add something like:
  "${ghdashboardwithtoken}/bin/ghdashboardwithtoken"
# Then visit localhost:port to see the dashboard. Use optional query parameter 'org' to
# filter results to a specific organisation.
```
