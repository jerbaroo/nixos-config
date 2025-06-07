{
  programs.bat.enable = true; # Required to avoid '[bat warning]: Unknown theme'.
  programs.git = {
    aliases = {
      a = "add";
      b = "branch";
      co = "checkout";
      c = "commit";
      cl = "clone";
      d = "diff";
      l = "log";
      p = "pull";
      pu = "push";
      r = "reset";
      s = "status";
    };
    delta.enable = true;
    enable = true;
    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
    };
    userName = "jerbaroo";
    userEmail = "jerbaroo.work@pm.me";
  };
}
